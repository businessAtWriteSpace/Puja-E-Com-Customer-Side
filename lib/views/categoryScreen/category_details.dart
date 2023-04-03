import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/widgets/background.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import 'item_details.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }
  
  switchCategory(title) {
    if(controller.subcat.contains(title)){
      productMethod = FirestoreServices.getSubProducts(title);
    } else{
      productMethod = FirestoreServices.getProducts(title);
    }
  }
  var controller = Get.put(ProductController());

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.fontFamily(bold).white.make(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      controller.subcat.length,
                          (index) => "${controller.subcat[index]}".text.size(12).fontFamily(semibold).color(darkFontGrey).makeCentered()
                          .box.white.rounded.size(120, 50).margin(EdgeInsets.symmetric(horizontal: 4)).make()
                      .onTap(() { 
                        switchCategory("${controller.subcat[index]}");
                        setState(() {});
                          })
                  ),
                ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  );
                }else if(snapshot.data!.docs.isEmpty){
                  return Expanded(
                    child: Center(
                        child: "No Products Found".text.color(darkFontGrey).make()),
                  );
                }
                else{

                  var data = snapshot.data!.docs;

                  return Expanded(
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 250, mainAxisSpacing: 8, crossAxisSpacing: 8),
                        itemBuilder:(context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(data[index]['p_imgs'][0], height: 150, width: 200, fit: BoxFit.cover,),

                              "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              10.heightBox,
                              "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16).make(),
                              10.heightBox,
                            ],
                          ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM
                              .outerShadowSm.padding(EdgeInsets.all(12)).make().onTap(() {
                                controller.checkifFav(data[index]);
                            Get.to(() =>ItemDetails(title: "${data[index]['p_name']}", data: data[index],));
                          });
                        }),
                  );
                }
              },
            ),
          ],
        )
      )
    );
  }
}
