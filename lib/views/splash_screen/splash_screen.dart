

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widgets/applogo.dart';
import '../auth_screen/login.dart';
import '../homeScreen/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   //Method to change the screen
  changeScreen(){
    Future.delayed(Duration(seconds: 3), (){
      //using getx
      auth.authStateChanges().listen((User? user) {
        if(user==null && mounted){
          Get.to(() =>LoginScreen());
        }else{
          Get.to(()=>Home());
        }
      });
    });
  }
  @override
  void initState(){
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //using Velocity X
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
                child: Image.asset(icSplashBg, width: 300)),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
            //Splash Screen UI Completed.
          ],
        ),
      ),
    );
  }
}
