import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Controller/SplashController.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/watch.svg',
          width: 150, // Set the desired width
          height: 150, // Set the desired height
        ),
      ),
    );
  }
}
