import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/home_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/categoryScreen/item_details.dart';
import 'package:e_commerce_app/views/homeScreen/search_screen.dart';
import 'package:e_commerce_app/widgets/home_buttons.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../consts/lists.dart';
import 'components/featured_button.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if(controller.searchController.text.isNotEmptyAndNotNull) {
                          Get.to(() => SearchScreen(
                                title: controller.searchController.text,
                              ));
                        }
                      }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: search,
                  hintStyle: TextStyle(
                    color: textfieldGrey,
                  )
                ),
              ),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //swiper brands
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.asset(
                              slidersList[index], fit: BoxFit.fill,
                            ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make(),
                          );
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) => homeButtons(
                        height: context.screenHeight*0.15,
                        width: context.screenWidth/2.5,
                        icon: index==0? icTodaysDeal:icFlashDeal,
                        title: index==0? deal:flashSale,
                      )),
                    ),

                    10.heightBox,
                    //second Swiper
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.asset(
                              secondSlidersList[index], fit: BoxFit.fill,
                            ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make(),
                          );
                        }),

                    //Some More home buttons
                    10.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3,
                                (index) => homeButtons(
                              height: context.screenHeight*0.15,
                              width: context.screenWidth/3.5,
                              icon: index==0? icTopCategories:index==1?icBrands:icTopSeller,
                              title: index==0? topCategories:index==1?brand:top,
                            ))
                    ),

                    //featured categories
                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featured.text.color(darkFontGrey).size(18).fontFamily(semibold).make()),
                    20.heightBox,
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                      child: Row(

                        children: List.generate(2,
                                (index) => Column(
                                  children: [
                                    featuredButton(icon: featuredImages1[index], title: featuredTitles1[index]),
                                    10.heightBox,
                                    featuredButton(icon: featuredImages2[index], title: featuredTitles2[index]),
                                  ],
                                )).toList(),
                      ),
                    ),

                    //featured Products

                    20.heightBox,
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: redColor,
                      ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            featuredProd.text.white.fontFamily(bold).size(18).make(),
                            10.heightBox,
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder(
                                future: FirestoreServices.getFeaturedProducts(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if(!snapshot.hasData){
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(redColor),
                                      ),
                                    );
                                  }
                                  else if(snapshot.data!.docs.isEmpty){
                                    return "No featured products".text.white.makeCentered();
                                  }
                                  else {
                                    var featuredData = snapshot.data!.docs;
                                      return Row(
                                          children: List.generate(
                                              featuredData.length,
                                              (index) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.network(
                                                        featuredData[index]['p_imgs'][0],
                                                        width: 130,
                                                        height: 130,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      10.heightBox,
                                                      "${featuredData[index]['p_name']}"
                                                          .text
                                                          .fontFamily(semibold)
                                                          .color(darkFontGrey)
                                                          .make(),
                                                      10.heightBox,
                                                      "${featuredData[index]['p_price']}".numCurrency
                                                          .text
                                                          .color(redColor)
                                                          .fontFamily(bold)
                                                          .size(16)
                                                          .make(),
                                                      10.heightBox,
                                                    ],
                                                  )
                                                      .box
                                                      .white
                                                      .margin(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4))
                                                      .roundedSM
                                                      .padding(
                                                          EdgeInsets.all(8))
                                                      .make().onTap(() {
                                                Get.to(() => ItemDetails(
                                                  title:"${featuredData[index]['p_name']}",
                                                  data: featuredData[index],));
                                              }),
                                          ));
                                    }
                                  }
                              ),
                            )
                          ],
                        ),
                    ),

                    //3rd Swiper
                    20.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.asset(
                              secondSlidersList[index], fit: BoxFit.fill,
                            ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make(),
                          );
                        }),

                    //All products Section
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                        child: "All Products".text.fontFamily(bold).color(darkFontGrey).size(18).make()),
                    20.heightBox,

                    StreamBuilder(
                        stream: FirestoreServices.allProducts(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(!snapshot.hasData){
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              ),
                            );
                          }
                          else{
                            var allProductsdata = snapshot.data!.docs;
                            return GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allProductsdata.length ,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 300) ,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(allProductsdata[index]['p_imgs'][0], height: 200, width: 200, fit: BoxFit.cover,),
                                      10.heightBox,
                                      "${allProductsdata[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                      10.heightBox,
                                      "${allProductsdata[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
                                      10.heightBox,
                                    ],
                                  ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(12)).make()
                                  .onTap(() {
                                    Get.to(() => ItemDetails(
                                        title:"${allProductsdata[index]['p_name']}",
                                        data: allProductsdata[index],));
                                  });
                                });
                          }
                        }),
                  ],
                ),
              ),
            ),


          ],
        ),
      )
    );
  }
}
