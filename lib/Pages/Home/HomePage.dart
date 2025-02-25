import 'package:flutter/material.dart';
import 'package:remind/Pages/Home/Tabs/Home.dart';
import 'package:remind/Pages/Home/Tabs/Profile.dart';
import 'package:remind/Pages/Home/Tabs/Settings.dart'; // Ensure correct import

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            ProfileTab(),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}
