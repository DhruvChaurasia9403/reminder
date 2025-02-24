import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:remind/Controller/AuthMethods.dart';
import 'package:remind/Utility/Images.dart';
import 'package:remind/Widgets/WelcomeHeading.dart';
import 'AuthCard.dart';

class Authpage extends StatelessWidget {
  Authpage({super.key});

  AuthMethods auth = Get.put(AuthMethods());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const welcomeHeading(),
                const SizedBox(height: 70),
                AuthCard(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or", style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    bool success = await auth.signInWithGoogle(context);
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Google sign-in failed")),
                      );
                    }
                  },
                  icon: SvgPicture.asset(
                    AssetsImage.googleSVG,
                    height: 24,
                    width: 24,
                  ),
                  label: Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}