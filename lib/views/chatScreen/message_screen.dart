import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/chats_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/chatScreen/chat_screen.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Messages".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else if(snapshot.data!.docs.isEmpty){
            return "No messages yet!".text.color(darkFontGrey).makeCentered();
          } else{
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemCount: data.length ,
                          itemBuilder: (BuildContext context, int index) {
                             return Card(
                               child: ListTile(
                                 onTap: () {
                                   Get.to(() => ChatScreen(),
                                     arguments: [data[index]['sellername'], data[index]['toId']],
                                   );
                                 },
                                 leading: CircleAvatar(
                                   backgroundColor: redColor,
                                   child: Icon(Icons.person,
                                   color: whiteColor,),
                                 ),
                                 title: "${data[index]['sellername']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                 subtitle: "${data[index]['last_msg']}".text.make(),
                               ),
                             );

                          }
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}