import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/lists.dart';
import 'package:e_commerce_app/controller/auth_controller.dart';
import 'package:e_commerce_app/views/auth_screen/login.dart';
import 'package:e_commerce_app/views/chatScreen/message_screen.dart';
import 'package:e_commerce_app/widgets/background.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../controller/profile_controller.dart';
import '../../services/firestore_services.dart';
import '../ordersScreen/orders_screen.dart';
import '../wishlistScreen/wishlist_screen.dart';
import 'components/details_card.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            }
            else{
              var data = snapshot.data!.docs[0];
              return SafeArea(
                  child: Column(
                    children: [
                      //edit profile button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.edit, color: whiteColor,)).onTap(() {
                          controller.nameController.text = data['name'];
                          Get.to(() => EditProfileScreen(data: data));
                        }),
                      ),
                      //users details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            data['imageUrl']==''?
                            Image.asset(imgProfile2, width: 100, fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make():
                            Image.network(data['imageUrl'], width: 100, fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),
                            10.widthBox,
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}".text.fontFamily(semibold).white.make(),
                                "${data['email']}".text.white.make(),
                              ],
                            )),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: whiteColor,
                                    )
                                ),
                                onPressed: () async{
                                  await Get.put(AuthController()).signOutMethod(context);
                                  Get.offAll(()=>LoginScreen());
                                }, child: "Sign out".text.fontFamily(semibold).white.make()
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: FirestoreServices.getCounts(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(!snapshot.hasData){
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                ),
                              );
                            }
                            else {
                              var countData = snapshot.data;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                      count: countData[0].toString(),
                                      title: "In your cart",
                                      width: context.screenWidth / 3.4),
                                  detailsCard(
                                      count: countData[1].toString(),
                                      title: "In your wishlist",
                                      width: context.screenWidth / 3.4),
                                  detailsCard(
                                      count: countData[2].toString(),
                                      title: "Your orders",
                                      width: context.screenWidth / 3.4),
                                ],
                              );
                            }
                         }
                      ),

                      //button section
                      ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                switch(index) {
                                  case 0:
                                    Get.to(()=> OrdersScreen());
                                    break;
                                  case 1:
                                    Get.to(()=> WishlistScreen());
                                    break;
                                  case 2:
                                    Get.to(()=> MessagesScreen());
                                    break;
                                }
                              },
                              leading: Image.asset(profileButtonIcon[index], width: 21,),
                              title: profileButtonList[index].text.fontFamily(semibold)
                                  .color(darkFontGrey).make(),

                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: lightGrey,
                            );
                          },
                          itemCount: profileButtonList.length)
                          .box.white
                          .rounded.padding(EdgeInsets.symmetric(horizontal: 16))
                          .shadowSm.margin(EdgeInsets.all(12)).make()
                          .box.color(redColor).make(),
                    ],
                  ));
            }
          },

        )
      )
    );
  }
}
