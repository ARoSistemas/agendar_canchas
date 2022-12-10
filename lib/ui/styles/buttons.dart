import 'package:flutter/material.dart';

class StylesButtons {
  //
  static final ButtonStyle myStyle = ElevatedButton.styleFrom(
    primary: Colors.blue.shade300,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: const TextStyle(fontSize: 20, color: Colors.green),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(color: Colors.black38),
    ),
  );

  static final ButtonStyle myStyleSave = ElevatedButton.styleFrom(
    primary: const Color.fromARGB(255, 214, 212, 212),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: const TextStyle(fontSize: 20, color: Colors.green),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(color: Colors.black38),
    ),
  );
}
