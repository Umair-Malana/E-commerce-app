import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Bottom%20Navbar/nav_bar_screen.dart';
import 'package:e_store/Order%20placing/gen_order_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerAddress,
  required String customerPhone,
  required String customerToken,
}) async {
  EasyLoading.show(status: "Please wait");
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection("cartproducts")
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection("orders")
              .doc(user.uid)
              .set({
            "userId": user.uid,
            "customerName": customerName,
            "customerAddress": customerAddress,
            "customerPhone": customerPhone,
            "customerDevicetoken": customerToken,
            "orderStatus": false,
            "createdOn": DateTime.now()
          });
          await FirebaseFirestore.instance
              .collection("orders")
              .doc(user.uid)
              .collection("confirmOrders")
              .doc(orderId)
              .set({
            "name": data["name"],
            "price": data["price"],
            "images": data["imageurl"],
            "description": data["description"],
            "productId": data["productId"],
            "docId": data["docId"],
            "productQuantity": data["productQuantity"],
            "orderStatus":false
          });
          await FirebaseFirestore.instance
              .collection("cart")
              .doc(user.uid)
              .collection("cartproducts")
              .doc(data["productId"])
              .delete();
        }
      }
      Get.snackbar(
        "Order",
        "Order is placed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 247, 250, 220),
      );
      Get.offAll(() => const NavBarScreen());
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
