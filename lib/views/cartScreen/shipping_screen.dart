import 'package:e_commerce_app/controller/cart_controller.dart';
import 'package:e_commerce_app/views/cartScreen/payment_screen.dart';
import 'package:e_commerce_app/widgets/button.dart';
import 'package:e_commerce_app/widgets/textField.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if(controller.addressController.text.length>10 && controller.cityController.text.isNotEmpty && controller.stateController.text.isNotEmpty
                && controller.countryController.text.isNotEmpty && controller.postalController.text.isNotEmpty && controller.phoneController.text.isNotEmpty){
              Get.to(() =>PaymentMethods());
            } else if(controller.addressController.text.length<10 ){
              VxToast.show(context, msg: "Please fill the full address");
            }
            else{
              VxToast.show(context, msg: "Please fill the form completely");
            }

          },
          color: redColor,
          title: "Continue",
          textColor: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            textField(hint: "Address", isPass: false, label: "Address", controller: controller.addressController ),
            textField(hint: "City", isPass: false, label: "City", controller: controller.cityController),
            textField(hint: "State", isPass: false, label: "State", controller: controller.stateController),
            textField(hint: "Country", isPass: false, label: "Country", controller: controller.countryController),
            textField(hint: "Postal Code", isPass: false, label: "Postal Code", controller: controller.postalController),
            textField(hint: "Phone no.", isPass: false, label: "Phone no.", controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
