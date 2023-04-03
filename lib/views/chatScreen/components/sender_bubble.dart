import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:intl/intl.dart' as intl;
Widget senderBubble(DocumentSnapshot data){

  var t = data['created_on']==null? DateTime.now(): data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);

  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
        color: data['uid']==currentUser!.uid?redColor: darkFontGrey,
        borderRadius: BorderRadius.circular(10),),
    child: Column(
      crossAxisAlignment: data['uid']==currentUser!.uid?CrossAxisAlignment.end: CrossAxisAlignment.start,
      children: [
        "${data['msg']}".text.white.size(16).make(),
        10.heightBox,
        time.text.color(whiteColor.withOpacity(0.5)).make(),

      ],
    ),
  );

}