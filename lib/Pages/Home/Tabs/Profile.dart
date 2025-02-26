import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remind/Pages/Login/Login.dart';
import 'package:remind/Utility/Images.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.photoURL ?? AssetsImage.defaultPic),
          ),
          SizedBox(height: 20),
          Text(user?.displayName ?? 'No display name',),
          SizedBox(height: 10),
          Text(user?.email ?? 'No email'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Get.offAll(() => AuthLoginForm());
            },
            child: Text('Log Out'),
          )
        ],
      ),
    );
  }
}