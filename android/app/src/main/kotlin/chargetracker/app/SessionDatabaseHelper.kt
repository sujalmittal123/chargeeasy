package chargetracker.app

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import java.io.File

class SessionDatabaseHelper(private val context: Context) {

    private fun getDatabase(): SQLiteDatabase {
        val appFlutterDir = File(context.filesDir.parentFile, "app_flutter")
        if (!appFlutterDir.exists()) {
            appFlutterDir.mkdirs()
        }
        val dbFile = File(appFlutterDir, "chargetracker_db.sqlite")
        val oldDbFile = File(appFlutterDir, "chargeeasy_db.sqlite")
        if (!dbFile.exists() && oldDbFile.exists()) {
            oldDbFile.renameTo(dbFile)
        }
        val db = SQLiteDatabase.openOrCreateDatabase(dbFile.path, null)
        createTablesIfNotExist(db)
        return db
    }

    private fun createTablesIfNotExist(db: SQLiteDatabase) {
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS sessions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                start_ts INTEGER NOT NULL,
                end_ts INTEGER,
                start_pct INTEGER NOT NULL,
                end_pct INTEGER,
                avg_w REAL,
                peak_w REAL,
                avg_ma REAL,
                max_temp REAL,
                charger_id INTEGER,
                charger_type TEXT NOT NULL
            );
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS samples (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                session_id INTEGER NOT NULL,
                ts INTEGER NOT NULL,
                ma REAL NOT NULL,
                mv REAL NOT NULL,
                temp REAL NOT NULL,
                pct INTEGER NOT NULL
            );
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS health_snapshots (
                ts INTEGER PRIMARY KEY,
                est_capacity_mah INTEGER NOT NULL,
                health_pct REAL NOT NULL,
                cycle_count INTEGER NOT NULL
            );
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS settings (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL
            );
        """.trimIndent())
    }

    fun startSession(startTs: Long, startPct: Int, chargerType: String): Long {
        val db = getDatabase()
        val values = ContentValues().apply {
            put("start_ts", startTs)
            put("start_pct", startPct)
            put("charger_type", chargerType)
        }
        return db.insert("sessions", null, values)
    }

    fun insertSample(sessionId: Long, ts: Long, ma: Double, mv: Double, temp: Double, pct: Int) {
        val db = getDatabase()
        val values = ContentValues().apply {
            put("session_id", sessionId)
            put("ts", ts)
            put("ma", ma)
            put("mv", mv)
            put("temp", temp)
            put("pct", pct)
        }
        db.insert("samples", null, values)
    }

    fun finishSession(sessionId: Long, endTs: Long, endPct: Int, initialChargeCounterUah: Long, finalChargeCounterUah: Long, designCapacityMah: Int): Boolean {
        val db = getDatabase()
        var startTs = 0L
        var startPct = 0

        val sessionCursor = db.rawQuery("SELECT start_ts, start_pct FROM sessions WHERE id = ?", arrayOf(sessionId.toString()))
        if (sessionCursor.moveToFirst()) {
            startTs = sessionCursor.getLong(0)
            startPct = sessionCursor.getInt(1)
        }
        sessionCursor.close()

        val durationMs = endTs - startTs
        val pctChange = Math.abs(endPct - startPct)

        // Ignore sessions shorter than 60 s or with less than 1% change
        if (durationMs < 60_000L || pctChange < 1) {
            db.delete("sessions", "id = ?", arrayOf(sessionId.toString()))
            db.delete("samples", "session_id = ?", arrayOf(sessionId.toString()))
            return false
        }

        // Compute averages and peaks from samples
        val samplesCursor = db.rawQuery(
            "SELECT ma, mv, temp FROM samples WHERE session_id = ?",
            arrayOf(sessionId.toString())
        )

        var sumW = 0.0
        var peakW = 0.0
        var sumMa = 0.0
        var maxTemp = 0.0
        var count = 0

        while (samplesCursor.moveToNext()) {
            val ma = samplesCursor.getDouble(0)
            val mv = samplesCursor.getDouble(1)
            val temp = samplesCursor.getDouble(2)
            val w = Math.abs(ma * mv) / 1_000_000.0

            sumW += w
            if (w > peakW) peakW = w
            sumMa += ma
            if (temp > maxTemp) maxTemp = temp
            count++
        }
        samplesCursor.close()

        val avgW = if (count > 0) sumW / count else 0.0
        val avgMa = if (count > 0) sumMa / count else 0.0

        val updateValues = ContentValues().apply {
            put("end_ts", endTs)
            put("end_pct", endPct)
            put("avg_w", avgW)
            put("peak_w", peakW)
            put("avg_ma", avgMa)
            put("max_temp", maxTemp)
        }
        db.update("sessions", updateValues, "id = ?", arrayOf(sessionId.toString()))

        // Health estimation if level change >= 30%
        if (endPct - startPct >= 30 && designCapacityMah > 0) {
            val levelDelta = (endPct - startPct).toDouble()
            val counterDeltaUah = finalChargeCounterUah - initialChargeCounterUah
            if (counterDeltaUah > 0) {
                val counterDeltaMah = counterDeltaUah / 1000.0
                val estCapacity = (counterDeltaMah / (levelDelta / 100.0)).toInt()
                if (estCapacity in 800..20000) {
                    saveDailyHealthSnapshot(db, estCapacity, designCapacityMah)
                }
            }
        }

        return true
    }

    private fun saveDailyHealthSnapshot(db: SQLiteDatabase, estCapacity: Int, designCapacityMah: Int) {
        val now = System.currentTimeMillis()
        val oneDayAgo = now - 24 * 60 * 60 * 1000L

        // Check if snapshot exists in last 24h
        val cursor = db.rawQuery("SELECT COUNT(*) FROM health_snapshots WHERE ts > ?", arrayOf(oneDayAgo.toString()))
        var recentCount = 0
        if (cursor.moveToFirst()) {
            recentCount = cursor.getInt(0)
        }
        cursor.close()

        if (recentCount == 0) {
            val healthPct = ((estCapacity.toDouble() / designCapacityMah.toDouble()) * 100.0).coerceIn(40.0, 100.0)

            // Compute cumulative cycles = total charged % / 100
            val cyclesCursor = db.rawQuery("SELECT SUM(end_pct - start_pct) FROM sessions WHERE end_pct > start_pct", null)
            var totalPct = 0.0
            if (cyclesCursor.moveToFirst()) {
                totalPct = cyclesCursor.getDouble(0)
            }
            cyclesCursor.close()
            val cycleCount = (totalPct / 100.0).toInt()

            val snapshotValues = ContentValues().apply {
                put("ts", now)
                put("est_capacity_mah", estCapacity)
                put("health_pct", healthPct)
                put("cycle_count", cycleCount)
            }
            db.insertWithOnConflict("health_snapshots", null, snapshotValues, SQLiteDatabase.CONFLICT_REPLACE)
        }
    }
}
