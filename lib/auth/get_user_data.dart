import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataState extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getuserData(String userId) async {
    final QuerySnapshot userdata = await firebaseFirestore
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();

    return userdata.docs;
  }
}
