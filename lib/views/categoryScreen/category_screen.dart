import 'package:e_commerce_app/consts/lists.dart';
import 'package:e_commerce_app/widgets/background.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../controller/product_controller.dart';
import 'category_details.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 200),
              itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(categoryImages[index], height: 120,
                width: 200, fit: BoxFit.cover,),
                10.heightBox,
                categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make(),
              ],
            ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {
              controller.getSubCategories(categoriesList[index]);
              Get.to(()=>CategoryDetails(title: categoriesList[index]));
            });
              }),
        ),
      )
    );
  }
}
