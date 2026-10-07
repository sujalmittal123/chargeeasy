package chargetracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class PowerConnectionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val serviceIntent = Intent(context, ChargingForegroundService::class.java)

        when (action) {
            Intent.ACTION_POWER_CONNECTED -> {
                serviceIntent.action = ChargingForegroundService.ACTION_START_TRACKING
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            }
            Intent.ACTION_POWER_DISCONNECTED -> {
                serviceIntent.action = ChargingForegroundService.ACTION_STOP_TRACKING
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            }
        }
    }
}
