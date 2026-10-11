package chargetracker.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.os.BatteryManager
import android.os.Build
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

open class ChargeTrackerWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH_WIDGET) {
            refreshBatterySnapshot(context)
            updateAllWidgets(context)
        }
    }

    companion object {
        const val ACTION_REFRESH_WIDGET = "chargetracker.app.ACTION_REFRESH_WIDGET"

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)
            val percent = prefs.getInt("last_percent", -1).let { if (it >= 0) it else getLiveBatteryPercent(context) }
            val current = prefs.getInt("last_current", 0)
            val watts = prefs.getFloat("last_watts", 0f)
            val temp = prefs.getFloat("last_temp", 0f).let { if (it > 0) it else getLiveTemperature(context) }
            val healthStr = prefs.getString("last_health_str", null) ?: getLiveHealth(context)
            val isCharging = prefs.getBoolean("last_is_charging", false)
            val isTransparent = prefs.getBoolean("widget_transparent_theme", true)

            val views = RemoteViews(context.packageName, R.layout.widget_2x1)

            // Background theme
            if (isTransparent) {
                views.setInt(R.id.widget_root, "setBackgroundResource", R.drawable.widget_glass_transparent_bg)
            } else {
                views.setInt(R.id.widget_root, "setBackgroundResource", R.drawable.widget_glass_bg)
            }

            // Data binding
            views.setTextViewText(R.id.widget_percent, if (percent >= 0) "$percent%" else "--%")
            
            val powerText = if (watts > 0) {
                String.format(Locale.US, "%.1fW · %dmA", watts, current)
            } else if (current != 0) {
                "${current}mA"
            } else {
                "-- W"
            }
            views.setTextViewText(R.id.widget_current, powerText)
            views.setTextViewText(R.id.widget_temp, if (temp > 0) String.format(Locale.US, "%.1f°C", temp) else "--°C")
            views.setTextViewText(R.id.widget_health, healthStr)

            val statusText = if (isCharging) "Charging ⚡" else "Discharging"
            views.setTextViewText(R.id.widget_status, statusText)

            // Click to open main app
            val openAppIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val openAppPendingIntent = PendingIntent.getActivity(
                context, 0, openAppIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, openAppPendingIntent)

            // Click refresh icon
            val refreshIntent = Intent(context, ChargeTrackerWidget::class.java).apply {
                action = ACTION_REFRESH_WIDGET
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 101, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_refresh_btn, refreshPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        fun updateAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            
            val smallComponent = ComponentName(context, ChargeTrackerWidget::class.java)
            val smallIds = appWidgetManager.getAppWidgetIds(smallComponent)
            for (id in smallIds) {
                updateAppWidget(context, appWidgetManager, id)
            }

            val largeComponent = ComponentName(context, ChargeTrackerWidgetLarge::class.java)
            val largeIds = appWidgetManager.getAppWidgetIds(largeComponent)
            for (id in largeIds) {
                ChargeTrackerWidgetLarge.updateAppWidget(context, appWidgetManager, id)
            }
        }

        fun refreshBatterySnapshot(context: Context) {
            try {
                val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
                val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED)) ?: return

                val percent = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                val tempTenths = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
                val temp = if (tempTenths > 0) tempTenths / 10.0f else 28.0f
                val voltageMv = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0)
                val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN)
                val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
                val health = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_GOOD)

                var currentMa = batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW) ?: 0
                if (Math.abs(currentMa) > 20000) currentMa /= 1000
                if (isCharging && currentMa < 0) currentMa = -currentMa
                if (!isCharging && currentMa > 0) currentMa = -currentMa

                val voltageV = voltageMv / 1000.0f
                val watts = Math.abs(voltageV * (currentMa / 1000.0f))

                val healthStr = when (health) {
                    BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
                    BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
                    BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
                    BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
                    else -> "Normal"
                }

                val prefs = context.getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)
                prefs.edit()
                    .putInt("last_percent", percent)
                    .putInt("last_current", currentMa)
                    .putFloat("last_watts", watts)
                    .putFloat("last_temp", temp)
                    .putFloat("last_voltage", voltageV)
                    .putString("last_health_str", healthStr)
                    .putBoolean("last_is_charging", isCharging)
                    .putLong("last_update", System.currentTimeMillis())
                    .apply()
            } catch (e: Exception) {
                // Ignore snapshot read errors
            }
        }

        private fun getLiveBatteryPercent(context: Context): Int {
            val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            return intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, 50) ?: 50
        }

        private fun getLiveTemperature(context: Context): Float {
            val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val tempTenths = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 300) ?: 300
            return tempTenths / 10.0f
        }

        private fun getLiveHealth(context: Context): String {
            val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val health = intent?.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_GOOD) ?: BatteryManager.BATTERY_HEALTH_GOOD
            return if (health == BatteryManager.BATTERY_HEALTH_GOOD) "Good" else "Normal"
        }
    }
}

class ChargeTrackerWidgetLarge : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ChargeTrackerWidget.ACTION_REFRESH_WIDGET) {
            ChargeTrackerWidget.refreshBatterySnapshot(context)
            ChargeTrackerWidget.updateAllWidgets(context)
        }
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)
            val percent = prefs.getInt("last_percent", -1).let { if (it >= 0) it else 50 }
            val current = prefs.getInt("last_current", 0)
            val watts = prefs.getFloat("last_watts", 0f)
            val temp = prefs.getFloat("last_temp", 28.5f)
            val voltageV = prefs.getFloat("last_voltage", 4.12f)
            val healthStr = prefs.getString("last_health_str", "Good") ?: "Good"
            val isCharging = prefs.getBoolean("last_is_charging", false)
            val lastUpdate = prefs.getLong("last_update", System.currentTimeMillis())
            val estimateStr = prefs.getString("last_estimate_str", null)
            val isTransparent = prefs.getBoolean("widget_transparent_theme", true)

            val views = RemoteViews(context.packageName, R.layout.widget_4x2)

            // Background theme
            if (isTransparent) {
                views.setInt(R.id.widget_large_root, "setBackgroundResource", R.drawable.widget_glass_transparent_bg)
            } else {
                views.setInt(R.id.widget_large_root, "setBackgroundResource", R.drawable.widget_glass_bg)
            }

            // Hero metrics
            views.setTextViewText(R.id.widget_large_percent, "$percent%")
            
            val statusLabel = if (isCharging) {
                if (watts > 18) "Super Fast ⚡" else if (watts > 10) "Fast Charging ⚡" else "Charging ⚡"
            } else {
                "Discharging"
            }
            views.setTextViewText(R.id.widget_large_status, statusLabel)

            val wattsLabel = if (watts > 0) {
                String.format(Locale.US, "%.1f W · %s%d mA", watts, if (current > 0) "+" else "", current)
            } else {
                String.format(Locale.US, "%d mA", current)
            }
            views.setTextViewText(R.id.widget_large_watts, wattsLabel)

            val dynamicEstimate = estimateStr ?: if (isCharging) {
                "Charging actively"
            } else {
                "Operating normally"
            }
            views.setTextViewText(R.id.widget_large_estimate, dynamicEstimate)

            // Grid Metrics
            views.setTextViewText(R.id.widget_large_temp, String.format(Locale.US, "%.1f°C", temp))
            views.setTextViewText(R.id.widget_large_health, healthStr)
            views.setTextViewText(R.id.widget_large_voltage, String.format(Locale.US, "%.2f V", voltageV))

            val timeFormatter = SimpleDateFormat("HH:mm", Locale.getDefault())
            views.setTextViewText(R.id.widget_large_updated, timeFormatter.format(Date(lastUpdate)))

            // PendingIntents
            val openAppIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val openAppPendingIntent = PendingIntent.getActivity(
                context, 1, openAppIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_large_root, openAppPendingIntent)

            val refreshIntent = Intent(context, ChargeTrackerWidgetLarge::class.java).apply {
                action = ChargeTrackerWidget.ACTION_REFRESH_WIDGET
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 102, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_large_refresh_btn, refreshPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
