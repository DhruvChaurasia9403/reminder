import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../Controller/AuthMethods.dart';
class Sliderbutton extends StatelessWidget {
  const Sliderbutton({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthMethods authMethods = AuthMethods();
    return Column(
      children: [
        SlideAction(
          onSubmit: () async {
            bool res = await authMethods.signInWithGoogle(context);
            if (!res) {
              // Handle sign-in failure
            }
          },
          text: "Login",
          sliderRotate: true,
          innerColor: Theme.of(context).colorScheme.primaryContainer,
          outerColor: Theme.of(context).colorScheme.onPrimaryContainer,
          sliderButtonIconSize: 25,
          sliderButtonIcon: const Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }
}
