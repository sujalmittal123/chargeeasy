package chargeeasy.app

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

class UsageStatsHelper(private val context: Context) {
    fun getTopAppsDrain(): List<Map<String, Any>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return emptyList()
        }

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - (24 * 60 * 60 * 1000) // Last 24 hours

        val stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime)
        
        var totalForegroundTime = 0L
        stats?.forEach { 
            totalForegroundTime += it.totalTimeInForeground
        }
        if (totalForegroundTime == 0L) return emptyList()

        val pm = context.packageManager
        
        return stats?.filter { it.totalTimeInForeground > 0 }
            ?.sortedByDescending { it.totalTimeInForeground }
            ?.take(10)
            ?.map {
                val appName = try {
                    val info = pm.getApplicationInfo(it.packageName, 0)
                    pm.getApplicationLabel(info).toString()
                } catch (e: PackageManager.NameNotFoundException) {
                    it.packageName
                }
                
                val drainPercent = (it.totalTimeInForeground.toFloat() / totalForegroundTime.toFloat()) * 100
                
                mapOf(
                    "packageName" to it.packageName,
                    "appName" to appName,
                    "foregroundTimeMs" to it.totalTimeInForeground,
                    "estimatedDrainPercent" to drainPercent
                )
            } ?: emptyList()
    }
}
