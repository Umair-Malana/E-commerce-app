import 'package:flutter/material.dart';

class UiHelp {
 

  Color orange = Colors.orange;
  Color white = Colors.white;
  Color black = Colors.black;
  Color red = const Color.fromRGBO(183, 28, 28, 1);
  
 Color grey = const Color.fromARGB(255, 76, 73, 73);

  

  moveToNextscreen(context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  errorMessage(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  successMessage(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
