// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SimpleTextInput extends StatelessWidget {
  String hintText;
  TextEditingController controller;

  SimpleTextInput(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: "Poppins"),
      ),
    );
  }
}
