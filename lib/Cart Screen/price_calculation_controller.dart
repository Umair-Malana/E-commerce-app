import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PriceCalculationControllerer extends GetxController {
  // RxDouble totalprice = 0.0.obs;
  RxDouble fullprice = 0.0.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // @override
  // void onInit() {
  //   // priceCalculator();
  //   fullPrice(snapshot);
  //   super.onInit();
  // }

  // Future<void> priceCalculator() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
  //       .collection("cart")
  //       .doc(auth.currentUser!.uid)
  //       .collection("cartproducts")
  //       .get();

  //   double sum = 0.0;

  //   for (final doc in snapshot.docs) {
  //     final data = doc.data();
  //     if (data.isNotEmpty && data.containsKey("price")) {
  //       sum += (data["price"] as num).toDouble();
  //     }
  //   }
  //   totalprice.value = sum;
  // }

  void fullPrice(List snapshot) {
    double sum = 0.0;
    for (final doc in snapshot) {
      sum += (doc["price"] as num).toDouble();
    }
    fullprice.value = sum;
  }

  // void increasePrice(List snapshot, String docId) {
  //   double sum = 0.0;
  //   for (final doc in snapshot) {
  //     sum += (doc["price"] as num) * (doc["productQuantity"] as num).toDouble();
  //   }
  //   fullprice.value = sum;
  // }

  // void decreaseQuantity(String docId, int productQuantity, price) {
  //   if (productQuantity > 1) {
  //     firestore
  //         .collection("cart")
  //         .doc(auth.currentUser!.uid)
  //         .collection("cartproducts")
  //         .doc(docId)
  //         .update({
  //       "productQuantity": productQuantity - 1, // Decrease quantity
  //       "price": (productQuantity * price )
  //     });
  //   }
  // }
}
