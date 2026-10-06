package chargeeasy.app

import android.content.Context
import androidx.work.Constraints
import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.concurrent.TimeUnit

class WorkManagerHelper {
    companion object {
        fun setupWorkers(context: Context) {
            val constraints = Constraints.Builder()
                .build()

            val snapshotWorkRequest = PeriodicWorkRequest.Builder(
                HealthSnapshotWorker::class.java,
                6, TimeUnit.HOURS
            ).setConstraints(constraints).build()

            val idleWorkRequest = PeriodicWorkRequest.Builder(
                IdleSamplingWorker::class.java,
                15, TimeUnit.MINUTES
            ).setConstraints(constraints).build()

            WorkManager.getInstance(context).enqueue(snapshotWorkRequest)
            WorkManager.getInstance(context).enqueue(idleWorkRequest)
        }
    }
}

class HealthSnapshotWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    override fun doWork(): Result {
        val prefs = applicationContext.getSharedPreferences("ChargeEasyPrefs", Context.MODE_PRIVATE)
        prefs.edit().putLong("last_health_snapshot_time", System.currentTimeMillis()).apply()
        return Result.success()
    }
}

class IdleSamplingWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    override fun doWork(): Result {
        return Result.success()
    }
}
