import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/controller/chats_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:get/get.dart';

import 'components/sender_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.sellerName}".text.fontFamily(semibold).color(darkFontGrey).make(),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx( () => controller.isloading.value?Center(
                child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation(redColor),
               )):
              Expanded(child: StreamBuilder(
                stream: FirestoreServices.getChatMsgs(controller.chatDocId.toString()),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ),
                    );
                  }
                  else if(snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: "Send a message....".text.color(darkFontGrey).make(),
                    );
                  } else{
                    return ListView(
                      children: snapshot.data!.docs.mapIndexed((currentValue, index) {
                        var data = snapshot.data!.docs[index];
                        return Align(
                          alignment: data['uid']==currentUser!.uid?  Alignment.centerRight: Alignment.centerLeft,
                            child: senderBubble(data));
                      }).toList(),
                    );
                  }
                },
              )),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    hintText: "Enter your message..",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        )
                    ),
                  ),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();

                    } ,
                    icon: Icon(Icons.send, color: redColor,)),
              ],
            ).box.height(80).padding(EdgeInsets.all(12)).margin(EdgeInsets.only(bottom: 8)).make()
          ],
        ),
      ),
    );
  }
}
