import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Bottom%20Navbar/nav_bar_screen.dart';
import 'package:e_store/admin/admin_panel.dart';
import 'package:e_store/auth/get_user_data.dart';
import 'package:e_store/auth/login_screen.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AuthState extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final getUserdata = Get.put(GetUserDataState());

  var obsecure = true.obs;

  Future<UserCredential?> signUp(
      String email, String password, String username) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "email": email,
        "password": password,
        "username": username,
        "userId": userCredential.user!.uid,
        "isAdmin": false,
        "isActive": true,
        "createdOn": DateTime.now()
      }).then((onValue) {
        Get.offAll(() => LoginScreen());
      });
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("error", "$e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.emailVerified) {
        var userData = await getUserdata.getuserData(userCredential.user!.uid);
        if (userData[0]["isAdmin"] == true) {
          Get.offAll(() => AdminPanel());
        } else {
          Get.offAll(() => NavBarScreen());
        }
      } else {
        Get.snackbar("Error", "Email not verified",
            snackPosition: SnackPosition.BOTTOM);
      }

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<void> forgetPass(
    String email,
  ) async {
    try {
      EasyLoading.show(status: "Please wait");
      await auth.sendPasswordResetEmail(email: email);
      EasyLoading.dismiss();
      Get.snackbar("Email sent", "Password reset email sent to $email",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => LoginScreen());
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }
}
