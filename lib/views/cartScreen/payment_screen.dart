import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/consts/lists.dart';
import 'package:e_commerce_app/controller/cart_controller.dart';
import 'package:e_commerce_app/views/homeScreen/home.dart';
import 'package:e_commerce_app/widgets/button.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(() =>
      Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value?Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(redColor),
            ),
          ):ourButton(
            onPress: () async {
              controller.placeMyOrder(orderPaymentMethod: paymentMethods[controller.paymentIndex.value], totalAmount: controller.totalP.value);
              await controller.clearCart();
              VxToast.show(context, msg: "Order placed successfully!!");
              Get.offAll(Home());
            },
            color: redColor,
            title: "Place my order",
            textColor: whiteColor,
          ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx( () =>Column(
              children: List.generate(paymentMethods.length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.changePaymentIdx(index);
                        },
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:controller.paymentIndex.value==index?redColor: Colors.transparent,
                              width: 4,
                            )
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.asset(
                                paymentMethodImgs[index], width: double.infinity,
                                height: 120, fit: BoxFit.cover,
                                colorBlendMode:controller.paymentIndex.value==index? BlendMode.darken: BlendMode.color,
                                color:controller.paymentIndex.value==index? Colors.black.withOpacity(0.4): Colors.transparent,
                              ),
                              controller.paymentIndex.value==index?Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  activeColor: Colors.green,
                                    value: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                    onChanged: (value) {

                                }),
                              ): Container(),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: paymentMethods[index].text.white.fontFamily(semibold).size(16).make()),
                            ],
                          ),
                        ),
                      )
              ),
            ),
          ),
        ),

      ),
    );
  }
}
