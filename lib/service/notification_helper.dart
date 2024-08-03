import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz; // Corrected import

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  static init() {
    print('Initializing Notifications');
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    _notification.initialize(settings);

    const channel = AndroidNotificationChannel(
      'important_notification',
      'My Channel',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
    );

    _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    tz.initializeTimeZones();
    print('Notifications Initialized');
  }

  static Future<void> scheduleNotification(
      tz.TZDateTime tzDateTime, String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('chime'), // No file extension
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notification.zonedSchedule(
      0,
      title,
      body,
      tzDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
