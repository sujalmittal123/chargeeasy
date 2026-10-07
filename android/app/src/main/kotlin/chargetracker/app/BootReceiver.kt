package chargetracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

import android.content.IntentFilter
import android.os.BatteryManager

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            val prefs = context.getSharedPreferences("ChargeTrackerPrefs", Context.MODE_PRIVATE)
            val wasRunning = prefs.getBoolean("service_running", false)
            
            // Also check current battery state
            val batteryStatus: Intent? = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isPlugged = (status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL)

            if (wasRunning || isPlugged) {
                val serviceIntent = Intent(context, ChargingForegroundService::class.java).apply {
                    action = ChargingForegroundService.ACTION_START_TRACKING
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            }
        }
    }
}
