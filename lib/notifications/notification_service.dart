import 'dart:core';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(initSettings);
  }

  static Future<void> showDailyQuote(int hour, int minute, String quote, String author) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_quote_channel', 'Daily Quote',
      channelDescription: 'Daily Quote Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // await _notifications.zonedSchedule(
    //   0,
    //   'Quote of the Day',
    //   '"$quote" - $author',
    //   _nextInstanceOfTime(hour, minute),
    //   platformDetails,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //   UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  // static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  //   final tzNow = tz.TZDateTime.now(tz.local);
  //   var scheduled = tz.TZDateTime(tz.local, tzNow.year, tzNow.month, tzNow.day, hour, minute);
  //   if (scheduled.isBefore(tzNow)) scheduled = scheduled.add(const Duration(days: 1));
  //   return scheduled;
  // }
}
