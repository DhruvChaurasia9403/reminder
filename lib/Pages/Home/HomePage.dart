import 'package:flutter/material.dart';
import 'package:remind/Pages/Home/Tabs/Home.dart';

import 'Tabs/Profile.dart';
import 'Tabs/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            ProfileTab(),
            settingsTab(),
          ],
        ),
      ),
    );
  }
}