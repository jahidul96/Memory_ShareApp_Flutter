// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/auth_fb.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:path/path.dart' as p;
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/custome_button.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 30),
          InkWell(
            onTap: () => getImage(),
            child: Center(
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        _image!,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.appbarColor,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextComp(text: "Add a profile picture.")
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 30),
          loading
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 40,
                      ),
                      TextComp(text: "Creating Account Wait...")
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: CustomButton(
                    text: "Create Account",
                    onPressed: () => createAccount(),
                  ),
                ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15),
          //   child:
          //       CustomButton(text: "SIGN UP", onPressed: () => createAccount()),
          // ),
        ],
      ),
    );
  }
}
