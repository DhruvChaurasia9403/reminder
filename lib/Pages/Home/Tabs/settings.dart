import 'package:flutter/material.dart';

class settingsTab extends StatelessWidget {
  const settingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Settings Page', ),
          SizedBox(height: 20),
          Text('Manage your notifications and other settings here.'),
        ],
      ),
    );
  }
}