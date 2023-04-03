import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../consts/firebase_consts.dart';

class AuthController extends GetxController{
  var isloading = false.obs;
  //textControllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  //login
  Future<UserCredential?> login({context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch(e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

   //sign up
  Future<UserCredential?> signUp({email, password, context}) async{
    UserCredential? userCredential;
    try{
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }
  
  //storing data
 storeUserData({name, password, email}) async{
    DocumentReference store = await firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name' : name,
      'password' : password,
      'email' : email,
      'imageUrl' : '',
      'id': currentUser!.uid,
      'cart_count':"00",
      'wishlist_count':"00",
      'order_count':"00",
    });
 }
 //sign out
 signOutMethod(context) async{
    try{
      await auth.signOut();
    } catch(e){
      VxToast.show(context, msg: e.toString());
    }
 }

}