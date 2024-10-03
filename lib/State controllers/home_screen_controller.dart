import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var selectedCategory = "All Products".obs;
  var snapData = [].obs;
  var categories = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    firebaseFirestore.collection("products").snapshots().listen((snapShots) {
      var allProducts = snapShots.docs;

      snapData.value = allProducts;

      categories.value = allProducts
          .map((doc) => (doc["category"] as String?)?.trim().toLowerCase())
          .toSet()
          .toList();
    });
  }
}
