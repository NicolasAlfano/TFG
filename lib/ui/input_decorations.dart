import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon,
      IconData? suffixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 20),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.deepPurple)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.deepPurple)
            : null);
  }
}
