import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getCustomerdevicetoken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token;
    } else {
      throw Exception("Token is empty");
    }
  } catch (e) {
    throw Exception(e);
  }
}
