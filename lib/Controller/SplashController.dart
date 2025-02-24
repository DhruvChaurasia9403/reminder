import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../Pages/Home/HomePage.dart';
import '../Pages/Login/Authpage.dart';
class SplashController extends GetxController{
  final auth = FirebaseAuth.instance;


  @override
  void onInit() async{
    super.onInit();
    await splashHandle();
  }

  Future<void> splashHandle() async{
    Future.delayed(const Duration(seconds:1), (){
      if(auth.currentUser==null){
        Get.to(()=>Authpage());
      }
      else{
        Get.to(()=>HomePage());
        print(auth.currentUser!.email);
      }
    });
  }
}