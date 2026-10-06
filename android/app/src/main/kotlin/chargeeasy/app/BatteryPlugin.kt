package chargeeasy.app

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

    private val BATTERY_STREAM_CHANNEL = "chargeeasy.app/battery_stream"
    private val BATTERY_COMMANDS_CHANNEL = "chargeeasy.app/battery_commands"

    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    private var isPolling = false
    private val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    private val prefs: SharedPreferences = context.getSharedPreferences("ChargeEasyPrefs", Context.MODE_PRIVATE)

    fun registerWith(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_COMMANDS_CHANNEL).setMethodCallHandler(this)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_STREAM_CHANNEL).setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDesignCapacity" -> {
                result.success(getDesignCapacity())
            }
            "startForegroundService" -> {
                val intent = Intent(context, ChargingForegroundService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                prefs.edit().putBoolean("service_running", true).apply()
                result.success(true)
            }
            "stopForegroundService" -> {
                val intent = Intent(context, ChargingForegroundService::class.java)
                context.stopService(intent)
                prefs.edit().putBoolean("service_running", false).apply()
                result.success(true)
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

        val data = mapOf(
            "currentMa" to currentMa,
            "voltageMv" to voltageMv,
            "temperatureC" to temperatureC,
            "percent" to percent,
            "status" to status,
            "plugged" to plugged,
            "health" to health,
            "chargeCounterUah" to chargeCounterUah,
            "designCapacityMah" to getDesignCapacity(),
            "technology" to technology,
            "timestamp" to System.currentTimeMillis()
        )

        eventSink?.success(data)
    }

    private var cachedDesignCapacity: Int? = null

    private fun getDesignCapacity(): Int {
        cachedDesignCapacity?.let { return it }
        val capacity = try {
            val file = File("/sys/class/power_supply/battery/charge_full_design")
            if (file.exists()) {
                val reader = BufferedReader(FileReader(file))
                val capacityStr = reader.readLine()
                reader.close()
                val cap = capacityStr?.trim()?.toIntOrNull() ?: -1
                if (cap > 20000) cap / 1000 else cap
            } else {
                -1
            }
        } catch (e: Exception) {
            -1
        }
        cachedDesignCapacity = capacity
        return capacity
    }
}
