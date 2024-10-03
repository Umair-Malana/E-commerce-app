import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Cart%20Screen/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartScreenController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addTocart(String name, String price, List imageurl,
      String description, String docId, int quantityIncrement) async {
    DocumentReference documentReference = firestore
        .collection("cart")
        .doc(auth.currentUser!.uid)
        .collection("cartproducts")
        .doc(docId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot["productQuantity"];
      int updatedQuantity = currentQuantity + quantityIncrement;

      
      double tPrice;
      if (snapshot["price"] is String) {
        tPrice = double.parse(snapshot["price"]);
      } else {
        tPrice = snapshot["price"];
      }

      double totalPrice = tPrice / currentQuantity * updatedQuantity;

      
      await documentReference.update({
        "productQuantity": updatedQuantity,
        "price": totalPrice,
      });

      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          "Cart Product",
          "This product alredy exists in the cart");
      Get.to(() => CartScreen());
    } else {
      await documentReference.set({
        "name": name,
        "price": double.parse(price), // Store as double
        "imageurl": imageurl,
        "description": description,
        "productId": docId,
        "productQuantity": 1, // Initial quantity
        "docId": docId
      });

      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          "Cart Product",
          "This product added to cart");
      Get.to(() => CartScreen());
    }
  }

  Future<void> deletefromCart(String productId) async {
    firestore
        .collection("cart")
        .doc(auth.currentUser!.uid)
        .collection("cartproducts")
        .doc(productId)
        .delete();
  }
}
