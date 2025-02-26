import 'package:flutter/material.dart';
import 'package:remind/Controller/NotificationController.dart';
import 'package:remind/main.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _timeController = TextEditingController();
  final NotificationController _notificationController = NotificationController(flutterLocalNotificationsPlugin);

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
              decoration: const InputDecoration(
                labelText: 'Enter time in seconds',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_timeController.text.isNotEmpty) {
                  int? seconds = int.tryParse(_timeController.text);
                  if (seconds != null && seconds > 0) {
                    _notificationController.scheduleNotification(seconds);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid positive number.')),
                    );
                  }
                }
              },
              child: const Text('Schedule Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _notificationController.showInstantNotification,
              child: const Text('Show Instant Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _notificationController.openExactAlarmSettings,
              child: const Text('Open Alarm Settings'),
            ),
          ],
        ),
      ),
    );
  }
}