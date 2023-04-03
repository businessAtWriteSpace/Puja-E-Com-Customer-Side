import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/controller/home_controller.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController{
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }
  var chats = firestore.collection(chatsCollection);
  var sellerName = Get.arguments[0];
  var sellerId = Get.arguments[1];
  var senderName = Get.find<HomeController>().username;
  var currentId  =currentUser!.uid;
  var msgController = TextEditingController();

  dynamic chatDocId;
  var isloading = false.obs;
  getChatId() async{
    isloading(true);
    await chats.where('users', isEqualTo: {
      sellerId: null, currentId: null
    }).limit(1).get().then((QuerySnapshot snapshot) {
      if(snapshot.docs.isNotEmpty){
        chatDocId = snapshot.docs.single.id;
      } else{
       chats.add({
         'created_on': null,
         'last_msg': '',
         'users': {sellerId: null, currentId: null},
         'toId': '',
         'fromId': '',
         'sellername': sellerName,
         'sendername': senderName,
       }).then((value) {
         chatDocId = value.id;
       });
      }
    });
    isloading(false);
  }
  sendMsg(msg) async{
    if(msg.trim().isNotEmpty){
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': sellerId,
        'fromId': currentId,
      });

      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}