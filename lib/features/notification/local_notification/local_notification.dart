import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:sign_lang_app/features/notification/local_notification/notification_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize timezone data
  tz.initializeTimeZones();
}

Future<void> showTestNotificationNow() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'daily_channel_id', // Same channel as before
    'Daily Notifications',
    channelDescription: 'Daily reminder notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
    presentAlert: true, // Show an alert (required for iOS 10+)
    presentBadge: true, // Update app badge number
    presentSound: true, // Play a sound
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    1,
    'Test Notification!',
    'This is a test notification!',
    platformDetails,
  );
}

Future<void> scheduleDailyNotification() async {
  final box = Hive.box<NotificationModel>('notificationsBox');

  // Prevent duplication: check if today's notification already exists
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  bool alreadyScheduled = box.values.any((n) {
    final nDate = DateTime(
        n.scheduledTime.year, n.scheduledTime.month, n.scheduledTime.day);
    return nDate == today;
  });

  if (alreadyScheduled) {
    log("Today's notification already scheduled.");
    return;
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'daily_channel_id',
    'Daily Notifications',
    channelDescription: 'Daily reminder notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  final tz.TZDateTime scheduledDate = _nextInstanceOfTime(10, 0);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Daily Reminder!',
    'Donnot forget to come back!',
    scheduledDate,
    platformDetails,
    matchDateTimeComponents: DateTimeComponents.time,
    androidScheduleMode: AndroidScheduleMode.exact,
  );
  box.add(NotificationModel(
    title: 'Daily Reminder!',
    body: 'Donnot forget to come back!',
    scheduledTime: scheduledDate.toLocal(),
  ));
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
