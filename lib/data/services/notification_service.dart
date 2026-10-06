import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
    
    // Create channels
    const androidChannel1 = AndroidNotificationChannel(
      'charging_monitor',
      'Charging Monitor',
      description: 'Shows live charging stats',
      importance: Importance.low,
    );
    const androidChannel2 = AndroidNotificationChannel(
      'alarms',
      'Battery Alarms',
      description: 'Alerts for temperature and charge level',
      importance: Importance.high,
    );
    const androidChannel3 = AndroidNotificationChannel(
      'guard_mode',
      'Guard Mode',
      description: 'Theft alarm',
      importance: Importance.max,
    );
    
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel1);
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel2);
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel3);
  }

  Future<void> showNotification(int id, String title, String body, String channelId) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
          importance: Importance.high,
        ),
      ),
    );
  }
}
