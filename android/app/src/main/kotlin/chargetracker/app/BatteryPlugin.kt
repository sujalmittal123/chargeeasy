package chargetracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.provider.Settings
import android.net.Uri
import android.content.SharedPreferences
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.BufferedReader
import java.io.FileReader
import android.os.Handler
import android.os.Looper

class BatteryPlugin(private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private val BATTERY_STREAM_CHANNEL = "chargetracker.app/battery_stream"
    private val BATTERY_COMMANDS_CHANNEL = "chargetracker.app/battery_commands"

    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    private var isPolling = false
    private val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    private val prefs: SharedPreferences = context.getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)

    fun registerWith(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_COMMANDS_CHANNEL).setMethodCallHandler(this)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_STREAM_CHANNEL).setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDesignCapacity" -> {
                result.success(getDesignCapacity())
            }
            "isForegroundServiceRunning" -> {
                result.success(ChargingForegroundService.isServiceRunning)
            }
            "startForegroundService" -> {
                val intent = Intent(context, ChargingForegroundService::class.java).apply {
                    action = ChargingForegroundService.ACTION_START_TRACKING
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                prefs.edit().putBoolean("service_running", true).apply()
                result.success(true)
            }
            "stopForegroundService" -> {
                val intent = Intent(context, ChargingForegroundService::class.java).apply {
                    action = ChargingForegroundService.ACTION_STOP_TRACKING
                }
                context.stopService(intent)
                prefs.edit().putBoolean("service_running", false).apply()
                result.success(true)
            }
            "toggleManualTracking" -> {
                val currentlyRunning = ChargingForegroundService.isServiceRunning
                if (currentlyRunning) {
                    val intent = Intent(context, ChargingForegroundService::class.java).apply {
                        action = ChargingForegroundService.ACTION_STOP_TRACKING
                    }
                    context.stopService(intent)
                    prefs.edit().putBoolean("service_running", false).apply()
                    result.success(false)
                } else {
                    val intent = Intent(context, ChargingForegroundService::class.java).apply {
                        action = ChargingForegroundService.ACTION_START_TRACKING
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context.startForegroundService(intent)
                    } else {
                        context.startService(intent)
                    }
                    prefs.edit().putBoolean("service_running", true).apply()
                    result.success(true)
                }
            }
            "setGuardMode" -> {
                val enabled = call.arguments as? Boolean ?: false
                prefs.edit().putBoolean("guard_mode", enabled).apply()
                result.success(true)
            }
            "setAlarmThresholds" -> {
                val args = call.arguments as? Map<String, Any> ?: return
                val editor = prefs.edit()
                args.forEach { (key, value) ->
                    when (value) {
                        is Int -> editor.putInt(key, value)
                        is Float -> editor.putFloat(key, value)
                        is Double -> editor.putFloat(key, value.toFloat())
                        is Boolean -> editor.putBoolean(key, value)
                    }
                }
                editor.apply()
                result.success(true)
            }
            "calibrateCurrentSign" -> {
                val isPositiveWhenCharging = call.arguments as? Boolean ?: true
                prefs.edit().putBoolean("calibrate_current_sign", isPositiveWhenCharging).apply()
                result.success(true)
            }
            "getUsageStats" -> {
                val helper = UsageStatsHelper(context)
                result.success(helper.getTopAppsDrain())
            }
            "requestIgnoreBatteryOptimizations" -> {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                intent.data = Uri.parse("package:" + context.packageName)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
                result.success(true)
            }
            "checkOemOptimizationStatus" -> {
                // Return some mock flag values for OEM settings, these would usually check against a DB of OEM package intents
                val map = mapOf(
                    "miui" to true,
                    "coloros" to false,
                    "emui" to false
                )
                result.success(map)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startPolling()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        stopPolling()
    }

    private val pollRunnable = object : Runnable {
        override fun run() {
            if (isPolling) {
                emitBatteryData()
                handler.postDelayed(this, 1000)
            }
        }
    }

    private fun startPolling() {
        if (!isPolling) {
            isPolling = true
            handler.post(pollRunnable)
        }
    }

    private fun stopPolling() {
        isPolling = false
        handler.removeCallbacks(pollRunnable)
    }

    private fun emitBatteryData() {
        val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        if (intent == null) return

        val voltageMv = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)
        val tempTenths = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
        val temperatureC = if (tempTenths != -1) tempTenths / 10.0 else -1.0
        val plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
        val health = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_UNKNOWN)
        val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN)
        val technology = intent.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Unknown"

        var currentMa = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        if (Math.abs(currentMa) > 20000) {
            currentMa /= 1000
        }
        
        val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
        val isPositiveWhenCharging = prefs.getBoolean("calibrate_current_sign", true)
        
        // Normalize sign
        if (isCharging) {
            if (isPositiveWhenCharging && currentMa < 0) currentMa = -currentMa
            if (!isPositiveWhenCharging && currentMa > 0) currentMa = -currentMa
        } else {
            if (isPositiveWhenCharging && currentMa > 0) currentMa = -currentMa
            if (!isPositiveWhenCharging && currentMa < 0) currentMa = -currentMa
        }

        val percent = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val chargeCounterUah = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)

        val computeTimeRemainingMs = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            try {
                batteryManager.computeChargeTimeRemaining()
            } catch (e: Exception) {
                -1L
            }
        } else {
            -1L
        }

        val designCap = getDesignCapacity()

        val data = mapOf(
            "currentMa" to currentMa,
            "voltageMv" to voltageMv,
            "temperatureC" to temperatureC,
            "percent" to percent,
            "status" to status,
            "plugged" to plugged,
            "health" to health,
            "chargeCounterUah" to chargeCounterUah,
            "designCapacityMah" to designCap,
            "chargeTimeRemainingMs" to computeTimeRemainingMs,
            "technology" to technology,
            "timestamp" to System.currentTimeMillis()
        )

        eventSink?.success(data)
    }

    private var cachedDesignCapacity: Int? = null

    private fun getDesignCapacity(): Int {
        cachedDesignCapacity?.let { if (it > 0) return it }

        // Method 1: Android internal PowerProfile via reflection (works on virtually all Android phones)
        try {
            val powerProfileClass = Class.forName("com.android.internal.os.PowerProfile")
            val powerProfile = powerProfileClass.getConstructor(Context::class.java).newInstance(context)
            val cap = powerProfileClass.getMethod("getBatteryCapacity").invoke(powerProfile) as? Double
            if (cap != null && cap > 0) {
                val capInt = cap.toInt()
                if (capInt in 800..25000) {
                    cachedDesignCapacity = capInt
                    return capInt
                }
            }
        } catch (e: Exception) {
            // PowerProfile reflection failed, continue to fallback methods
        }

        // Method 2: Charge counter & current percentage ratio
        try {
            val chargeCounterUah = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
            val percent = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            if (chargeCounterUah > 0 && percent > 0) {
                val computedMah = ((chargeCounterUah.toDouble() / 1000.0) / (percent.toDouble() / 100.0)).toInt()
                if (computedMah in 800..25000) {
                    cachedDesignCapacity = computedMah
                    return computedMah
                }
            }
        } catch (e: Exception) {
            // ignore
        }

        // Method 3: Expanded sysfs paths for rooted or custom OEM kernels
        val sysfsPaths = listOf(
            "/sys/class/power_supply/battery/charge_full_design",
            "/sys/class/power_supply/bms/charge_full_design",
            "/sys/class/power_supply/battery/charge_full",
            "/sys/class/power_supply/bms/charge_full"
        )
        for (path in sysfsPaths) {
            try {
                val file = File(path)
                if (file.exists() && file.canRead()) {
                    val reader = BufferedReader(FileReader(file))
                    val capacityStr = reader.readLine()
                    reader.close()
                    val cap = capacityStr?.trim()?.toIntOrNull() ?: -1
                    if (cap > 0) {
                        val finalCap = if (cap > 20000) cap / 1000 else cap
                        if (finalCap in 800..25000) {
                            cachedDesignCapacity = finalCap
                            return finalCap
                        }
                    }
                }
            } catch (e: Exception) {
                // ignore
            }
        }

        return -1
    }
}
