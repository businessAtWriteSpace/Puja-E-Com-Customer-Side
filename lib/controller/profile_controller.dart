
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:universal_io/io.dart';

class ProfileController extends GetxController{
  var profileImgPath = "".obs;
  var profileImgLink = '';
  var isloading = false.obs;
  //textfields controller
  var nameController = TextEditingController();
  var newpassController = TextEditingController();
  var oldpassController = TextEditingController();

  changeImage(context) async{
    try{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
      if(img==null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch(e) {
      VxToast.show(context, msg: e.toString());
    }
  }
  uploadProfileImg() async{
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImgLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async{
    var store = firestore.collection(usersCollection).doc(currentUser!.uid);
    await store.set({
      'name':name,
      'password': password,
      'imageUrl': imgUrl
    }, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPass({email, password, newpass}) async{
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpass);
    }).catchError((error) {
      print(error.toString());
    });
  }
}
