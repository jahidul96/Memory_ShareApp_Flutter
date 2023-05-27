// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SimpleTextInput extends StatelessWidget {
  String hintText;

  SimpleTextInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
