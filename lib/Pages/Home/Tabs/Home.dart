import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to the Home Page!'),
          SizedBox(height: 20),
          Text('This is some placeholder content for the home page.'),
        ],
      ),
    );
  }
}