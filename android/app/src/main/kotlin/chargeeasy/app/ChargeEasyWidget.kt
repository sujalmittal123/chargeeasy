package chargeeasy.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.SharedPreferences

open class ChargeEasyWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("ChargeEasyPrefs", Context.MODE_PRIVATE)
            val percent = prefs.getInt("last_percent", 0)
            val current = prefs.getInt("last_current", 0)

            val views = RemoteViews(context.packageName, R.layout.widget_2x1)
            views.setTextViewText(R.id.widget_percent, "$percent%")
            views.setTextViewText(R.id.widget_current, "${current}mA")

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

class ChargeEasyWidgetLarge : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val prefs = context.getSharedPreferences("ChargeEasyPrefs", Context.MODE_PRIVATE)
            val percent = prefs.getInt("last_percent", 0)
            val current = prefs.getInt("last_current", 0)
            val watts = prefs.getFloat("last_watts", 0f)
            val temp = prefs.getFloat("last_temp", 0f)

            val views = RemoteViews(context.packageName, R.layout.widget_4x2)
            views.setTextViewText(R.id.widget_large_percent, "$percent%")
            views.setTextViewText(R.id.widget_large_current, "${current}mA")
            views.setTextViewText(R.id.widget_large_watts, "${String.format("%.1f", watts)}W")
            views.setTextViewText(R.id.widget_large_temp, "${temp}°C")

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_large_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
