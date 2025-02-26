import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationController(this.flutterLocalNotificationsPlugin) {
    tz.initializeTimeZones();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (Platform.isAndroid) {
      var alarmStatus = await Permission.scheduleExactAlarm.status;
      var notificationStatus = await Permission.notification.status;

      if (!alarmStatus.isGranted) await Permission.scheduleExactAlarm.request();
      if (!notificationStatus.isGranted) await Permission.notification.request();
    }
  }

  Future<void> openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      );
      await intent.launch();
    }
  }

  Future<void> scheduleNotification(int seconds) async {
    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      await checkPermissions();
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'reminder_channel', // Must match channel ID in `NotificationDetails`
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder Alert',
      'Your scheduled notification is here!',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint("✅ Notification scheduled successfully in $seconds seconds.");
  }

  Future<void> showInstantNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is an instant notification!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );

    debugPrint("✅ Instant notification displayed!");
  }
}