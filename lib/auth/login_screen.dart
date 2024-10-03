

import 'package:e_store/auth/getx_state.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../ui/ui_helper.dart';
import '../widgets/container_btn.dart';
import '../widgets/customtext.dart';
import '../widgets/customtextfield.dart';
import 'Signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController forgetpassemail = TextEditingController();
  TextEditingController password = TextEditingController();
  UiHelp uiHelper = UiHelp();

  @override
  Widget build(BuildContext context) {
    final stateManage = Get.put(AuthState());
    

    return Scaffold(
      backgroundColor: uiHelper.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    height: 300,
                    width: Get.width,
                    child: Lottie.asset("assets/images/firstanim.json")),
                SizedBox(height: 20),
                CustomText(
                  fontSize: 20,
                  text: 'Login',
                  color: uiHelper.black,
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  preficIcon: Icon(Icons.email),
                  obscureText: false,
                  hintText: 'Email',
                  controller: email,
                ),
                SizedBox(height: 10),
                Obx(
                  () => CustomTextfield(
                    preficIcon: IconButton(
                        onPressed: () {
                          stateManage.obsecure.toggle();
                        },
                        icon: Icon(stateManage.obsecure.value
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    obscureText: stateManage.obsecure.value,
                    hintText: 'Password',
                    controller: password,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                height: 200,
                                child: Column(
                                  children: [
                                    CustomTextfield(
                                      preficIcon: Icon(Icons.email),
                                      obscureText: false,
                                      hintText: 'Email',
                                      controller: forgetpassemail,
                                    ),
                                    SizedBox(height: 20),
                                    Containerbutton(
                                        onTap: () {
                                          if (forgetpassemail.text.isNotEmpty) {
                                            stateManage.forgetPass(
                                                forgetpassemail.text.trim());
                                          } else {
                                            Get.snackbar(
                                                "Error", "Please check email");
                                          }
                                        },
                                        child: Text("send"),
                                        radius: 20,
                                        height: 40,
                                        width: 60)
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CustomText(
                        fontSize: 10,
                        text: "Forgotten password?",
                        color: uiHelper.black,
                      ),
                    )),
                SizedBox(height: 50),
                Containerbutton(
                  onTap: () async {
                    if (email.text.isEmpty || password.text.isEmpty) {
                      Get.snackbar("Error", "Check your credentials",
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      await stateManage.signIn(email.text, password.text);
                      
                    }
                  },
                  child: CustomText(
                      text: "Login", color: uiHelper.white, fontSize: 20),
                  radius: 20,
                  height: 50,
                  width: Get.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      fontSize: 15,
                      text: "Don't have an account?",
                      color: uiHelper.black,
                    ),
                    TextButton(
                        onPressed: () {
                          uiHelper.moveToNextscreen(context, SignupScreen());
                        },
                        child: Text("Sign Up"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
