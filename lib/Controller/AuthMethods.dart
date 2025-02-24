import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remind/Pages/Home/HomePage.dart';
import 'package:remind/Utility/Images.dart';
import '../Model/UserModel.dart';
import '../Pages/Login/Login.dart';
import '../Widgets/snackBar.dart';

class AuthMethods extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get authChanges => _auth.authStateChanges();

  RxBool isLoading = false.obs;

  Future<UserModel?> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Get.snackbar("Error", "Google sign-in was cancelled", snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL ?? AssetsImage.defaultPic,
          });
        }
        res = true;
        Get.offAll(() => HomePage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return res;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found for that email.", snackPosition: SnackPosition.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong password provided.", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", e.message.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(String email, String password, String name) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await initUser(email, name);
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password provided is too weak.", snackPosition: SnackPosition.BOTTOM);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "The account already exists for that email.", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", e.message.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOutUser() async {
    await _auth.signOut();
    Get.offAll(() => AuthLoginForm());
  }

  Future<void> initUser(String email, String name) async {
    var newUser = UserModel(
      id: _auth.currentUser!.uid,
      name: name,
      email: email,
      profileImage: AssetsImage.defaultPic,
      phoneNumber: "",
    );
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).set(newUser.toJson());
    } catch (e) {
      print(e);
    }
  }
}