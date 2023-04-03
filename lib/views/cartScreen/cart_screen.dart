import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/cart_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/cartScreen/shipping_screen.dart';
import 'package:e_commerce_app/widgets/button.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
          child: ourButton(
            color: redColor,
            textColor: whiteColor,
            onPress: (){
              Get.to(()=>ShippingDetails());
            },
            title: "Proceed to Shipping",
          )
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else if(snapshot.data!.docs.isEmpty){
            return Center(child: "Cart is empty".text.color(darkFontGrey).make());
          }
          else{
            var data = snapshot.data!.docs;
            controller.calculateTotalPrice(data);
            controller.productSnapshot = data;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(child: Container(
                    child: ListView.builder(
                      itemCount: data.length,
                        itemBuilder:(BuildContext context, int index) {
                        return ListTile(
                          leading: Image.network('${data[index]['image']}', width: 80, fit: BoxFit.cover,),
                          title: "${data[index]['title']} (x${data[index]['quantity']})".text.fontFamily(semibold).size(16).make(),
                          subtitle: "${data[index]['totalPrice']}".numCurrency.text.color(redColor).fontFamily(semibold).size(14).make(),
                          trailing: Icon(Icons.delete, color: redColor).onTap(() {
                            FirestoreServices.deleteDocument(data[index].id);
                          }) ,
                        );
                        }
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price".text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx(() => "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make()),
                    ],
                  ).box.padding(EdgeInsets.all(12)).
                  color(Colors.orange.shade100).width(context.screenWidth-60).
                  roundedSM.make(),
                  10.heightBox,
                ],
              ),
            );
          }
        },
      )
    );
  }
}
