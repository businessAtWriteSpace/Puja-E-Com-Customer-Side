import 'package:e_commerce_app/controller/auth_controller.dart';
import 'package:e_commerce_app/widgets/applogo.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widgets/background.dart';
import '../../widgets/textField.dart';
import '../../widgets/button.dart';
import '../homeScreen/home.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgWidget(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Join the  $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,

            Obx(()=>
              Column(
                children: [
                  textField(label: name, hint: nameHint, controller: nameController, isPass: false),
                  textField(label: email, hint: emailHint, controller: emailController, isPass: false),
                  textField(label: password, hint: passwordHint, controller: passwordController, isPass: true),
                  textField(label: retypePass, hint: passwordHint, controller: passwordRetypeController, isPass: true),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: const Text("Forgot Password"))),

                  Row(
                    children: [
                      Checkbox(
                        activeColor: redColor,
                        checkColor: whiteColor,
                          value: isCheck,
                          onChanged: (newVal) {
                          setState(() {
                            isCheck = newVal;
                          });
                          },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(text: const TextSpan(
                          children:[ TextSpan(
                          text: "I agree to the ",
                          style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                          )
                        ),
                          TextSpan(
                              text: tandC,
                              style: TextStyle(
                                fontFamily: regular,
                                color: redColor,
                              )
                          ),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )
                            ),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )
                            ),
                          ]
                        ),),
                      ),
                    ],
                  ),
                  5.heightBox,
                  controller.isloading.value?const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ):ourButton(color: isCheck==true?redColor:lightGrey, title: "Sign Up", textColor:whiteColor,
                      onPress: () async {
                       if(isCheck!=false) {
                         controller.isloading(true);
                         try{
                           await controller.signUp(context: context, email: emailController.text, password: passwordController.text).then((value){
                             return controller.storeUserData(
                               email: emailController.text,
                               password: passwordController.text,
                               name: nameController.text,
                             );
                           }).then((value) {
                             VxToast.show(context, msg: "Logged In Successfully!!");
                             Get.offAll(() => Home());
                           });

                         } catch(e){
                           auth.signOut();
                           VxToast.show(context, msg: e.toString());
                           controller.isloading(false);
                         }
                       }
                       })
                      .box
                      .width(context.screenWidth-50).make(),
                  10.heightBox,
                  //wrapping into Gesture detector of velocity X
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(color:fontGrey),),
                      Text("Sign In", style: TextStyle(color:redColor),).onTap(() {
                        Get.back();
                      }),
                    ],
                  )
                ],
              ).box.white.rounded.padding(EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make(),
            ),
          ],
        ),
      ),
    ));
  }
}
