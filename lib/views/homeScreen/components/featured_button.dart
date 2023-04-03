import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/views/categoryScreen/category_details.dart';
import 'package:get/get.dart';

Widget featuredButton({String?title, icon}) {
  return Row(
    children: [
      Image.asset(icon, height: 40, width: 60, fit: BoxFit.fill,),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  ).box.white.width(240)
      .margin(EdgeInsets.symmetric(horizontal: 4))
      .padding(EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make().onTap(() {
        Get.to(() =>
          CategoryDetails(title: title,));
  });
}