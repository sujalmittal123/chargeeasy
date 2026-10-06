package chargeeasy.app

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
        const val CHANNEL_ID       = "chargeeasy_monitor"
        const val ALARM_CHANNEL_ID = "chargeeasy_alarms"
        const val NOTIFICATION_ID  = 101
    }

    private lateinit var batteryManager: BatteryManager
    private lateinit var prefs: SharedPreferences
    private var wakeLock: PowerManager.WakeLock? = null
    private var mediaPlayer: MediaPlayer? = null

    private val handler = Handler(Looper.getMainLooper())
    private var isRunning = false
    private var overHeatCounter        = 0
    private var alreadyNotifiedFull    = false
    private var alreadyNotifiedLimit   = false
    private var alreadyNotifiedLowBatt = false

    // ── BroadcastReceiver ────────────────────────────────────────────────────────
    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            updateNotification(intent)
            checkAlarms(intent)
        }
    }

    // ── Lifecycle ────────────────────────────────────────────────────────────────
    override fun onCreate() {
        super.onCreate()
        batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        prefs = getSharedPreferences("ChargeEasyPrefs", Context.MODE_PRIVATE)
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "ChargeEasy::Monitor")
        createNotificationChannels()
        registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!isRunning) {
            isRunning = true
            wakeLock?.acquire(10 * 60 * 1000L)
            val stub = buildMonitorNotification("⚡ ChargeEasy Monitor", "Initialising…")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(NOTIFICATION_ID, stub,
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
            } else {
                startForeground(NOTIFICATION_ID, stub)
            }
            // Kick off 5 s poll loop to refresh notification even if no broadcast comes
            handler.post(pollRunnable)
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        handler.removeCallbacks(pollRunnable)
        unregisterReceiver(batteryReceiver)
        if (wakeLock?.isHeld == true) wakeLock?.release()
        mediaPlayer?.release()
    }

    // ── 5-second poll loop ───────────────────────────────────────────────────────
    private val pollRunnable = object : Runnable {
        override fun run() {
            if (!isRunning) return
            val battIntent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            if (battIntent != null) {
                updateNotification(battIntent)
                checkAlarms(battIntent)
            }
            handler.postDelayed(this, 5_000L)
        }
    }

    // ── Persistent monitor notification ─────────────────────────────────────────
    private fun updateNotification(intent: Intent) {
        var currentMa = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        if (Math.abs(currentMa) > 20_000) currentMa /= 1000      // µA → mA
        val voltageMv  = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 3700)
        val tempC      = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0
        val percent    = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val watts      = Math.abs(currentMa.toLong() * voltageMv) / 1_000_000.0
        val status     = intent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN)

        val statusStr = when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING    -> "⚡ Charging"
            BatteryManager.BATTERY_STATUS_FULL        -> "✅ Full"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "🔋 Discharging"
            else                                       -> "🔌 Not Charging"
        }
        val speedLabel = when {
            watts > 30 -> "Super Fast"
            watts > 15 -> "Fast"
            watts > 5  -> "Normal"
            watts > 0  -> "Slow"
            else       -> ""
        }
        val title   = "$statusStr · $percent%"
        val content = buildString {
            append("${Math.abs(currentMa)} mA · ${String.format("%.1f", watts)} W · ")
            append("${String.format("%.1f", tempC)}°C")
            if (speedLabel.isNotEmpty()) append(" · $speedLabel")
        }

        // Cache for home-screen widget
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
            this, 0, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE)
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

    // ── Alarm notification helper ────────────────────────────────────────────────
    private fun sendAlarmNotification(id: Int, title: String, body: String) {
        val pi = PendingIntent.getActivity(
            this, id, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE)
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

    // ── Alarm logic ──────────────────────────────────────────────────────────────
    private fun checkAlarms(intent: Intent) {
        val percent = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val tempC   = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0
        val plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
        val isCharging = plugged != 0

        // Guard mode – unplug detection
        if (prefs.getBoolean("guard_mode", false) && plugged == 0) {
            sendAlarmNotification(201, "⚠️ Guard Alert – Charger Removed",
                "ChargeEasy detected charger disconnection in Guard Mode. " +
                "If this was unintentional, reconnect the charger.")
            playLoudAlarm()
        }

        // Full charge (100 %)
        if (isCharging && percent == 100 && !alreadyNotifiedFull) {
            sendAlarmNotification(202, "✅ Battery Full",
                "Your battery has reached 100%. Unplug to prevent trickle-charge heat.")
            alreadyNotifiedFull = true
        } else if (percent < 99) {
            alreadyNotifiedFull = false
        }

        // Custom charge limit
        if (prefs.getBoolean("charge_limit_enabled", true)) {
            val limit = prefs.getInt("charge_limit", 80)
            if (isCharging && percent >= limit && !alreadyNotifiedLimit) {
                sendAlarmNotification(203, "🔋 Charge Limit: $limit% Reached",
                    "Unplug now to extend battery lifespan. " +
                    "Charging beyond $limit% causes extra electrochemical stress.")
                alreadyNotifiedLimit = true
            } else if (percent < limit - 2) {
                alreadyNotifiedLimit = false
            }
        }

        // Overheat – 60 s grace period at 5 s polling = 12 counts
        val maxTemp = prefs.getFloat("max_temp", 42.0f).toDouble()
        if (tempC >= maxTemp) {
            overHeatCounter++
            if (overHeatCounter >= 12) {
                sendAlarmNotification(204, "🌡️ Overheat Alert: ${String.format("%.1f", tempC)}°C",
                    "Battery temperature exceeds ${maxTemp}°C for over 60 seconds.\n" +
                    "Tips: Remove phone case • Move to cooler room • Reduce screen brightness.")
                overHeatCounter = 0
            }
        } else {
            overHeatCounter = 0
        }

        // Low battery (discharging)
        if (prefs.getBoolean("low_battery_enabled", true)) {
            val lowThresh = prefs.getInt("low_battery_threshold", 15)
            if (!isCharging && percent in 1..lowThresh && !alreadyNotifiedLowBatt) {
                sendAlarmNotification(205, "🪫 Low Battery: $percent%",
                    "Connect a charger to keep ChargeEasy monitoring active.")
                alreadyNotifiedLowBatt = true
            } else if (isCharging || percent > lowThresh + 5) {
                alreadyNotifiedLowBatt = false
            }
        }

        // Auto-stop when unplugged and guard mode is off
        if (plugged == 0 && !prefs.getBoolean("guard_mode", false)) {
            prefs.edit().putBoolean("service_running", false).apply()
            stopSelf()
        }
    }

    // ── Guard-mode audio alarm ───────────────────────────────────────────────────
    private fun playLoudAlarm() {
        if (mediaPlayer?.isPlaying == true) return
        try {
            mediaPlayer?.release()
            mediaPlayer = MediaPlayer.create(
                this, android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI)
            mediaPlayer?.isLooping = true
            mediaPlayer?.setVolume(1.0f, 1.0f)
            mediaPlayer?.start()
        } catch (e: Exception) {
            // Vibration fallback if alarm URI unavailable
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

    // ── Notification channels ────────────────────────────────────────────────────
    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = getSystemService(NotificationManager::class.java)

        nm.createNotificationChannel(NotificationChannel(
            CHANNEL_ID, "ChargeEasy Live Monitor", NotificationManager.IMPORTANCE_LOW
        ).apply { description = "Always-on battery telemetry notification" })

        nm.createNotificationChannel(NotificationChannel(
            ALARM_CHANNEL_ID, "ChargeEasy Alarms", NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Charge limit, overheat and guard-mode alerts"
            enableVibration(true)
            enableLights(true)
        })
    }
}
