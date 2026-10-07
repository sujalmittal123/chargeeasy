package chargetracker.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.media.MediaPlayer
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class ChargingForegroundService : Service() {

    companion object {
        const val CHANNEL_ID       = "chargetracker_monitor"
        const val ALARM_CHANNEL_ID = "chargetracker_alarms"
        const val NOTIFICATION_ID  = 101

        const val ACTION_START_TRACKING = "chargetracker.app.ACTION_START_TRACKING"
        const val ACTION_STOP_TRACKING  = "chargetracker.app.ACTION_STOP_TRACKING"

        var isServiceRunning = false
            private set
    }

    private lateinit var batteryManager: BatteryManager
    private lateinit var prefs: SharedPreferences
    private lateinit var dbHelper: SessionDatabaseHelper
    private var wakeLock: PowerManager.WakeLock? = null
    private var mediaPlayer: MediaPlayer? = null

    private val handler = Handler(Looper.getMainLooper())
    private var isTracking = false
    private var currentSessionId = -1L
    private var initialChargeCounterUah = 0L

    private var overHeatCounter        = 0
    private var alreadyNotifiedFull    = false
    private var alreadyNotifiedLimit   = false
    private var alreadyNotifiedLowBatt = false

    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (action == Intent.ACTION_POWER_DISCONNECTED) {
                stopTrackingSession()
                return
            }
            updateNotification(intent)
            checkAlarms(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        prefs = getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)
        dbHelper = SessionDatabaseHelper(this)
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "ChargeTracker::MonitorLock")

        createNotificationChannels()

        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_BATTERY_CHANGED)
            addAction(Intent.ACTION_POWER_DISCONNECTED)
        }
        registerReceiver(batteryReceiver, filter)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action

        if (action == ACTION_STOP_TRACKING) {
            stopTrackingSession()
            return START_NOT_STICKY
        }

        if (!isTracking) {
            startTrackingSession()
        }

        return START_STICKY
    }

    private fun startTrackingSession() {
        isTracking = true
        isServiceRunning = true
        prefs.edit().putBoolean("service_running", true).apply()

        // Acquire wake lock so sampling continues with screen off
        if (wakeLock?.isHeld != true) {
            wakeLock?.acquire(6 * 60 * 60 * 1000L) // up to 6 hours max
        }

        val stub = buildMonitorNotification("⚡ Charge Tracker Active", "Tracking charging telemetry…")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIFICATION_ID, stub, android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            startForeground(NOTIFICATION_ID, stub)
        }

        // Get initial battery state
        val battIntent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val startPct = if (battIntent != null) {
            battIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        } else {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }

        val plugged = battIntent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0
        val chargerType = when (plugged) {
            BatteryManager.BATTERY_PLUGGED_AC -> "AC Fast Charger"
            BatteryManager.BATTERY_PLUGGED_USB -> "USB Cable"
            BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Wireless Pad"
            else -> "Connected Charger"
        }

        val startTs = System.currentTimeMillis()
        initialChargeCounterUah = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER).toLong()

        currentSessionId = dbHelper.startSession(startTs, if (startPct > 0) startPct else 50, chargerType)

        // Poll every 5 seconds for sample recording and alarms
        handler.removeCallbacks(pollRunnable)
        handler.post(pollRunnable)
    }

    private fun stopTrackingSession() {
        if (!isTracking) return
        isTracking = false
        isServiceRunning = false
        handler.removeCallbacks(pollRunnable)

        val endTs = System.currentTimeMillis()
        val battIntent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val endPct = if (battIntent != null) {
            battIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        } else {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }

        val finalChargeCounterUah = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER).toLong()
        val designCap = prefs.getInt("design_capacity_mah", 0)

        if (currentSessionId > 0) {
            dbHelper.finishSession(
                currentSessionId,
                endTs,
                if (endPct > 0) endPct else 50,
                initialChargeCounterUah,
                finalChargeCounterUah,
                designCap
            )
            currentSessionId = -1L
        }

        prefs.edit().putBoolean("service_running", false).apply()

        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }

        stopForeground(true)
        stopSelf()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        isTracking = false
        isServiceRunning = false
        handler.removeCallbacks(pollRunnable)
        try {
            unregisterReceiver(batteryReceiver)
        } catch (e: Exception) {
            // ignore if not registered
        }
        if (wakeLock?.isHeld == true) wakeLock?.release()
        mediaPlayer?.release()
        prefs.edit().putBoolean("service_running", false).apply()
    }

    // ── 5-second sample recording loop ──────────────────────────────────────────
    private val pollRunnable = object : Runnable {
        override fun run() {
            if (!isTracking) return

            val battIntent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            if (battIntent != null) {
                var currentMa = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW).toDouble()
                if (Math.abs(currentMa) > 20_000) currentMa /= 1000.0 // µA → mA

                val isPositiveWhenCharging = prefs.getBoolean("calibrate_current_sign", true)
                val status = battIntent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN)
                val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL

                if (isCharging) {
                    if (isPositiveWhenCharging && currentMa < 0) currentMa = -currentMa
                    if (!isPositiveWhenCharging && currentMa > 0) currentMa = -currentMa
                }

                val voltageMv = battIntent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 3800).toDouble()
                val tempC = battIntent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 250) / 10.0
                val pct = battIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                val finalPct = if (pct >= 0) pct else batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

                val ts = System.currentTimeMillis()

                if (currentSessionId > 0) {
                    dbHelper.insertSample(currentSessionId, ts, currentMa, voltageMv, tempC, finalPct)
                }

                updateNotification(battIntent)
                checkAlarms(battIntent)
            }

            handler.postDelayed(this, 5_000L)
        }
    }

    // ── Persistent notification ──────────────────────────────────────────────────
    private fun updateNotification(intent: Intent) {
        var currentMa = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        if (Math.abs(currentMa) > 20_000) currentMa /= 1000
        val voltageMv = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 3800)
        val tempC = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0
        val percent = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val watts = Math.abs(currentMa.toLong() * voltageMv) / 1_000_000.0
        val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN)

        val statusStr = when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "⚡ Charging"
            BatteryManager.BATTERY_STATUS_FULL -> "✅ Fully Charged"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "🔋 Discharging"
            else -> "🔌 Connected"
        }
        val speedLabel = when {
            watts > 30 -> "Super Fast"
            watts > 15 -> "Fast"
            watts > 5 -> "Normal"
            watts > 0 -> "Slow"
            else -> ""
        }
        val title = "$statusStr · $percent%"
        val content = buildString {
            append("${Math.abs(currentMa)} mA · ${String.format("%.1f", watts)} W · ")
            append("${String.format("%.1f", tempC)}°C")
            if (speedLabel.isNotEmpty()) append(" · $speedLabel")
        }

        prefs.edit()
            .putInt("last_percent", percent)
            .putInt("last_current", currentMa)
            .putFloat("last_watts", watts.toFloat())
            .putFloat("last_temp", tempC.toFloat())
            .putLong("last_update", System.currentTimeMillis())
            .apply()

        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIFICATION_ID, buildMonitorNotification(title, content))
    }

    private fun buildMonitorNotification(title: String, content: String): android.app.Notification {
        val pi = PendingIntent.getActivity(
            this, 0, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setStyle(NotificationCompat.BigTextStyle().bigText(content))
            .setSmallIcon(android.R.drawable.ic_lock_idle_charging)
            .setContentIntent(pi)
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .build()
    }

    private fun sendAlarmNotification(id: Int, title: String, body: String) {
        val pi = PendingIntent.getActivity(
            this, id, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE
        )
        val notif = NotificationCompat.Builder(this, ALARM_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentIntent(pi)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .build()
        (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).notify(id, notif)
    }

    private fun checkAlarms(intent: Intent) {
        val percent = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val tempC = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0
        val plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
        val isCharging = plugged != 0

        if (prefs.getBoolean("guard_mode", false) && plugged == 0) {
            sendAlarmNotification(
                201, "⚠️ Guard Alert – Charger Removed",
                "Charge Tracker detected charger disconnection in Guard Mode."
            )
            playLoudAlarm()
        }

        if (isCharging && percent == 100 && !alreadyNotifiedFull) {
            sendAlarmNotification(
                202, "✅ Battery Full",
                "Your battery has reached 100%. Unplug to prevent trickle-charge stress."
            )
            alreadyNotifiedFull = true
        } else if (percent < 99) {
            alreadyNotifiedFull = false
        }

        if (prefs.getBoolean("charge_limit_enabled", true)) {
            val limit = prefs.getInt("charge_limit", 80)
            if (isCharging && percent >= limit && !alreadyNotifiedLimit) {
                sendAlarmNotification(
                    203, "🔋 Charge Limit: $limit% Reached",
                    "Unplug now to preserve cycle lifespan."
                )
                alreadyNotifiedLimit = true
            } else if (percent < limit - 2) {
                alreadyNotifiedLimit = false
            }
        }

        val maxTemp = prefs.getFloat("max_temp", 42.0f).toDouble()
        if (tempC >= maxTemp) {
            overHeatCounter++
            if (overHeatCounter >= 12) {
                sendAlarmNotification(
                    204, "🌡️ Overheat Alert: ${String.format("%.1f", tempC)}°C",
                    "Battery temperature exceeds ${maxTemp}°C for over 60 seconds."
                )
                overHeatCounter = 0
            }
        } else {
            overHeatCounter = 0
        }
    }

    private fun playLoudAlarm() {
        if (mediaPlayer?.isPlaying == true) return
        try {
            mediaPlayer?.release()
            mediaPlayer = MediaPlayer.create(this, android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI)
            mediaPlayer?.isLooping = true
            mediaPlayer?.setVolume(1.0f, 1.0f)
            mediaPlayer?.start()
        } catch (e: Exception) {
            vibrateAlarm()
        }
    }

    private fun vibrateAlarm() {
        val pattern = longArrayOf(0, 800, 200, 800, 200, 800)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as android.os.VibratorManager
            vm.defaultVibrator.vibrate(android.os.VibrationEffect.createWaveform(pattern, 0))
        } else {
            @Suppress("DEPRECATION")
            (getSystemService(Context.VIBRATOR_SERVICE) as android.os.Vibrator).vibrate(pattern, 0)
        }
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = getSystemService(NotificationManager::class.java)

        nm.createNotificationChannel(
            NotificationChannel(CHANNEL_ID, "Charge Tracker Live Monitor", NotificationManager.IMPORTANCE_LOW).apply {
                description = "Always-on charging session monitor"
            }
        )

        nm.createNotificationChannel(
            NotificationChannel(ALARM_CHANNEL_ID, "Charge Tracker Alarms", NotificationManager.IMPORTANCE_HIGH).apply {
                description = "Charge limit, overheat and unplug guard alerts"
                enableVibration(true)
                enableLights(true)
            }
        )
    }
}
