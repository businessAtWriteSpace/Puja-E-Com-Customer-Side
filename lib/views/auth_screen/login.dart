import 'package:e_commerce_app/controller/auth_controller.dart';
import 'package:e_commerce_app/views/auth_screen/sign_up.dart';
import 'package:e_commerce_app/widgets/applogo.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../../widgets/background.dart';
import '../../widgets/textField.dart';
import '../../widgets/button.dart';
import '../homeScreen/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,

            Obx(()=>Column(
                children: [
                  textField(label: email, hint: emailHint, isPass: false, controller: controller.emailController),
                  textField(label: password, hint: passwordHint, isPass: true, controller: controller.passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: Text("Forgot Password"))),
                  5.heightBox,
                  controller.isloading.value?const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ):ourButton(
                      color: redColor,
                      title: "Sign In",
                      textColor:whiteColor,
                      onPress: () async{
                        controller.isloading(true);
                        await controller.login(context: context).then((value){
                          if(value!=null){
                            VxToast.show(context, msg: "Logged in Successfully");
                            Get.offAll(() =>Home());
                          }
                          else{
                            controller.isloading(false);
                          }
                        });
                      })
                      .box
                      .width(context.screenWidth-50).make(),
                  5.heightBox,
                  Text("Create new account", style: TextStyle(color: fontGrey),),
                  5.heightBox,
                  ourButton(
                      color: Colors.orange.shade100,
                      title: "Sign Up", textColor:redColor,
                      onPress: () {
                        Get.to(() => SignupScreen());
                      })
                      .box
                      .width(context.screenWidth-50).make(),
                  10.heightBox,
                  Text("Sign In with", style: TextStyle(color: fontGrey),),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: lightGrey,
                        radius: 25,
                        child: Image.asset(socialIconList[index], width: 30,),
                      ),
                    ))
                  ),
                ],
              ).box.white.rounded.padding(EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make(),
            ),
          ],
        ),
      ),
    ));
  }
}
