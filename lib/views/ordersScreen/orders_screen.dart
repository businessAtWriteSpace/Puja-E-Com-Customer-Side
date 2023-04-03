import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/ordersScreen/orders_details.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else if(snapshot.data!.docs.isEmpty){
            return "No orders yet!".text.color(darkFontGrey).makeCentered();
          } else{
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index+1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                  title:  intl.DateFormat().add_yMd().format((data[index]['order_date'].toDate())).text.fontFamily(semibold).color(redColor).make(),
                  subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() =>OrdersDetails(data: data[index]));
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded, color: darkFontGrey,),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
