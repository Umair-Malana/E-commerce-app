import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final Widget preficIcon;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  const CustomTextfield({
    super.key,
    required this.preficIcon,
    required this.obscureText,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 1,
                color: Colors.grey.withOpacity(0.5))
          ]),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: const Color.fromRGBO(183, 28, 28, 1))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: const Color.fromRGBO(183, 28, 28, 1))),
            hintText: hintText,
            prefixIcon: preficIcon,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: const Color.fromRGBO(183, 28, 28, 1)))),
      ),
    );
  }
}
