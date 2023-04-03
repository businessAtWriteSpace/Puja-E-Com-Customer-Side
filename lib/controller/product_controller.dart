import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';

class ProductController extends GetxController{
  var colorIdx = 0.obs;
  var quantity = 0.obs;
  var totalPrice = 0.obs;
  var subcat = [];
  var isFav = false.obs;
  getSubCategories(title) async{
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name==title).toList();
    for (var e in s[0].subcategory){
      subcat.add(e);
    }
  }

  changeColorIdx(index) {
    colorIdx.value = index;
  }

  increaseQuantity(totalQuantity){
    if(quantity.value<totalQuantity){
      quantity.value++;
    }
  }

  decreaseQuantity(){
    if(quantity.value>0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price){
    totalPrice.value = price*quantity.value;
  }
  
  addToCart({title, img, sellername, color, qty, tPrice, context, vendorId}) async{
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'image': img,
      'sellerName': sellername,
      'color': color,
      'quantity': qty,
      'totalPrice': tPrice,
      'added_by': currentUser!.uid,
      'vendor_id': vendorId,
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    }
    );
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIdx.value = 0;
  }

  addtoWishList(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }
  removefromWishList(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkifFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else{
      isFav(false);
    }
  }
}