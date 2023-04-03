
import 'package:e_commerce_app/widgets/background.dart';
import 'package:e_commerce_app/widgets/button.dart';
import 'package:e_commerce_app/widgets/textField.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:universal_io/io.dart';
import '../../consts/consts.dart';
import '../../controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(() =>
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              data['imageUrl']=='' && controller.profileImgPath.isEmpty?Image.asset(imgProfile2,height: 100, width: 100, fit: BoxFit.cover,)
                  .box.roundedFull.clip(Clip.antiAlias).make()
              :data['imageUrl']!='' && controller.profileImgPath.isEmpty?
              Image.network(data['imageUrl'],height: 100, width: 100, fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                  :Image.file(File(controller.profileImgPath.value),height: 100, width: 100, fit: BoxFit.cover,)
                  .box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButton(
                title: "Change",
                color: redColor,
                textColor: whiteColor,
                onPress: (){
                  controller.changeImage(context);
                }
              ),
              Divider(),
              20.heightBox,
              textField(
                controller: controller.nameController,
                hint: nameHint,
                label: name,
                isPass: false,
              ),
              textField(
                controller: controller.oldpassController,
                hint: passwordHint,
                label: oldpass,
                isPass: true,
              ),
              textField(
                controller: controller.newpassController,
                hint: passwordHint,
                label: newpass,
                isPass: true,
              ),
              20.heightBox,
              controller.isloading.value? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ):SizedBox(
                width: context.screenWidth-60,
                child: ourButton(
                    title: "Save",
                    color: redColor,
                    textColor: whiteColor,
                    onPress: () async{
                      controller.isloading(true);
                      if(controller.profileImgPath.value.isNotEmpty){
                        await controller.uploadProfileImg();
                      }else{
                        controller.profileImgLink = data['imageUrl'];
                      }
                      //if old pass matches database
                      if(controller.newpassController.text.isNotEmpty && data['password']==controller.oldpassController.text){
                        await controller.changeAuthPass(
                          email: data['email'],
                          password: controller.oldpassController.text,
                          newpass: controller.newpassController.text,
                        );
                        await controller.updateProfile(
                          imgUrl: controller.profileImgLink,
                          name: controller.nameController.text,
                          password: controller.newpassController.text,
                        );
                        VxToast.show(context, msg: "Profile updated!!");
                      } else if(controller.newpassController.text.isEmpty){
                        VxToast.show(context, msg: "Enter new password!!");
                        controller.isloading(false);
                      }
                      else{
                        VxToast.show(context, msg: "Wrong old password!!");
                        controller.isloading(false);
                      }

                    }
                ),
              ),
            ],
          ).box.shadowSm.white.padding(EdgeInsets.all(16)).
          margin(EdgeInsets.only(top: 50, left: 12, right: 12)).rounded.make(),
        ) ,
      )
    );
  }
}
