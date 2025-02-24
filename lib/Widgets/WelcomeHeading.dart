
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remind/Utility/Images.dart';
class welcomeHeading extends StatelessWidget {
  const welcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SvgPicture.asset(
              height: 100,
              width: 100,
              AssetsImage.appSVG,
            ),
          ],
        ),
        const SizedBox(height : 20),
        Text("Remind",style:Theme.of(context).textTheme.headlineLarge?.copyWith(color:Theme.of(context).colorScheme.secondary)),
      ],
    );
  }
}
