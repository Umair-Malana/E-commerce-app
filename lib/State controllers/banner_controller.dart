import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchbannerUrls();
  }

  Future<void> fetchbannerUrls() async {
    try {
      QuerySnapshot bannerSnap = await firestore.collection("banners").get();
      if (bannerSnap.docs.isNotEmpty) {
        bannerUrls.value =
            bannerSnap.docs.map((doc) => doc["imageUrl"] as String).toList();
      }
    } catch (e) {}
  }
}
