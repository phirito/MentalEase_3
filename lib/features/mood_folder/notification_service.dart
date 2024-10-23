import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void initializeNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  scheduleDailyReminder(flutterLocalNotificationsPlugin);
}

void scheduleDailyReminder(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Mood Reminder',
    'Don\'t forget to log your mood today!',
    _nextInstanceOfTime(6, 0, 0),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'mood_reminder_channel',
        'Daily Mood Reminder',
        channelDescription: 'Reminder to log your daily mood',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minutes, int seconds) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, hour, minutes, seconds);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
