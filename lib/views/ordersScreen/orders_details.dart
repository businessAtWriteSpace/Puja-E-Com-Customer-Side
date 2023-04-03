import 'package:e_commerce_app/consts/consts.dart';

import 'components/order_place_details.dart';
import 'components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order details".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                color: Colors.black,
                icon: Icons.offline_pin_rounded,
                title: "Order Placed",
                showIfDone: data['order_placed']
              ),
              orderStatus(
                  color: Colors.blue.shade900,
                  icon: Icons.thumb_up,
                  title: "Order Confirmed",
                  showIfDone: data['order_confirmed']
              ),
              orderStatus(
                  color: Colors.yellow.shade700,
                  icon: Icons.emoji_transportation,
                  title: "Shipped",
                  showIfDone: data['order_on_delivery']
              ),
              orderStatus(
                  color: redColor,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showIfDone: data['order_delivered']
              ),
              Divider(),
              10.heightBox,
              Column(
                children: [

                  orderPlacedDetails(
                      d1: data['order_code'],
                      d2: data['Shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method"
                  ),
                  orderPlacedDetails(
                      d1: intl.DateFormat().add_yMd().format((data['order_date'].toDate())),
                      d2: data['payment_method'],
                      title1: "Order Date",
                      title2: "Payment Method"
                  ),
                  orderPlacedDetails(
                      d1: "Unpaid", //bcz we are doing only Cash on Delivery
                      d2: "Order Placed",
                      title1: "Payment Status",
                      title2: "Delivery Status"
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_country']}".text.make(),
                            "${data['order_by_postalCode']}".text.make(),
                            "${data['order_by_phone']}".text.make(),

                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}".text.color(redColor).fontFamily(bold).make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ).box.outerShadowLg.white.make(),
              Divider(),
              10.heightBox,
              "Ordered Product".text.size(16).color(darkFontGrey).fontFamily(semibold).makeCentered(),
              10.heightBox,
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children:  List.generate(data['orders'].length,
                        (index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                orderPlacedDetails(
                                  title1: data['orders'][index]['title'],
                                  title2: data['orders'][index]['tprice'],
                                  d1: "${data['orders'][index]['quantity']}x",
                                  d2: "Refundable"
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Container(
                                    width: 30,
                                    height: 20,
                                    color: Color(data['orders'][index]['color']),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                        }).toList(),
              ).box.outerShadowLg.white.margin(EdgeInsets.only(bottom: 4)).make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
