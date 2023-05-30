// ignore_for_file: use_build_context_synchronously, must_be_immutable, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/auth_fb.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:path/path.dart' as p;
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class AddPic extends StatefulWidget {
  String email;
  String password;
  String username;
  AddPic(
      {super.key,
      required this.email,
      required this.password,
      required this.username});

  @override
  State<AddPic> createState() => _AddPicState();
}

class _AddPicState extends State<AddPic> {
  File? _image;
  bool loading = false;

  getImage() async {
    try {
      var tempImg = await pickImage();
      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      alertUser(context: context, alertText: "Image pick issue!");
    }
  }

  createAccount() async {
    if (_image == null) {
      return alertUser(context: context, alertText: "Add a Profile pic");
    }

    setState(() {
      loading = true;
    });
    String fileName = p.basename(_image!.path);
    String imagePath = 'profileImages/${DateTime.now()}$fileName';

    var url = await uploadFile(
        image: _image!, imagePath: imagePath, context: context);

    registerUser(
        username: widget.username,
        email: widget.email,
        password: widget.password,
        context: context,
        profileUrl: url);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        title: TextComp(
          text: "Add Profile Picture",
          color: AppColors.whiteColor,
          size: 19,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            imagePickerPlaceholderComp(onTap: getImage, image: _image),

            const SizedBox(height: 30),
            // lodder component
            sendinglodingComp(
              loading: loading,
              loadderText: "Creating Account Wait...",
              btnText: "Create Account",
              onPressed: () => createAccount(),
            ),
          ],
        ),
      ),
    );
  }
}
