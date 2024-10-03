import 'package:flutter/material.dart';

class Containerbutton extends StatelessWidget {
  final dynamic onTap;
  final Widget child;
  final double radius;
  final double height;
  final double width;

  const Containerbutton(
      {super.key,
      required this.onTap,
      required this.child,
      required this.radius,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              offset: Offset(0, 3))
        ], borderRadius: BorderRadius.circular(radius), color: Colors.red[900]),
        child: child,
      ),
    );
  }
}
