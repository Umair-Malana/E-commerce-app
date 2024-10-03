import 'package:e_store/auth/getx_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../ui/ui_helper.dart';
import '../widgets/container_btn.dart';
import '../widgets/customtext.dart';
import '../widgets/customtextfield.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  UiHelp uiHelper = UiHelp();

  @override
  Widget build(BuildContext context) {
    final stateManage = Get.put(AuthState());

    return Scaffold(
      backgroundColor: uiHelper.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 300,
                width: Get.width,
                child: Lottie.asset("assets/images/firstanim.json"),
              ),
              SizedBox(
                height: 20,
              ),
              CustomText(
                fontSize: 20,
                text: 'Sign up',
                color: uiHelper.black,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                preficIcon: Icon(Icons.person),
                obscureText: false,
                hintText: 'Username',
                controller: username,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                preficIcon: Icon(Icons.email),
                obscureText: false,
                hintText: 'Email',
                controller: email,
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => CustomTextfield(
                  preficIcon: IconButton(
                    onPressed: () {
                      stateManage.obsecure.toggle();
                    },
                    icon: Icon(stateManage.obsecure.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: stateManage.obsecure.value,
                  hintText: 'Password',
                  controller: password,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Containerbutton(
                onTap: () async {
                  if (email.text.isEmpty ||
                      password.text.isEmpty ||
                      username.text.isEmpty) {
                    Get.snackbar("Error", "Check your cridentials");
                  } else {
                    UserCredential? userCredential = await stateManage.signUp(
                        email.text, password.text, username.text);
                    if (userCredential != null) {
                      Get.snackbar(
                          "Email verification", "Verification email sent",
                          snackPosition: SnackPosition.BOTTOM);

                      stateManage.logOut();
                      Get.offAll(() => LoginScreen());
                    } else {}
                  }
                },
                child: CustomText(
                  text: "Sign up",
                  color: uiHelper.white,
                  fontSize: 20,
                ),
                radius: 20,
                height: 50,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    fontSize: 15,
                    text: "Already have an account?",
                    color: uiHelper.black,
                  ),
                  TextButton(
                    onPressed: () {
                      uiHelper.moveToNextscreen(context, LoginScreen());
                    },
                    child: Text("Log in"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
