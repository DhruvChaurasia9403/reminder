import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../main.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    checkPermissions();
  }

  /// ✅ Request permissions for exact alarm & notifications
  Future<void> checkPermissions() async {
    if (Platform.isAndroid) {
      var alarmStatus = await Permission.scheduleExactAlarm.status;
      var notificationStatus = await Permission.notification.status;

      if (!alarmStatus.isGranted) await Permission.scheduleExactAlarm.request();
      if (!notificationStatus.isGranted) await Permission.notification.request();
    }
  }

  /// ✅ Open Exact Alarm Settings for Manual Permission Granting
  Future<void> _openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      );
      await intent.launch();
    }
  }

  /// ✅ Schedule Notification with User-Defined Time
  Future<void> _scheduleNotification() async {
    var alarmStatus = await Permission.scheduleExactAlarm.status;
    var notificationStatus = await Permission.notification.status;

    if (!alarmStatus.isGranted || !notificationStatus.isGranted) {
      await checkPermissions();
      return;
    }

    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a time in seconds.')),
      );
      return;
    }

    int? seconds = int.tryParse(_timeController.text);
    if (seconds == null || seconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive number.')),
      );
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder Alert',
      'Your scheduled notification is here!',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)), // Scheduled time
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Force exact scheduling
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled in $seconds seconds!')),
    );

    debugPrint("✅ Notification scheduled successfully in $seconds seconds.");
  }

  /// ✅ Show Instant Notification
  Future<void> _showInstantNotification() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Set Timer for Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter time in seconds',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: const Text('Schedule Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showInstantNotification,
              child: const Text('Show Instant Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openExactAlarmSettings,
              child: const Text('Open Alarm Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
