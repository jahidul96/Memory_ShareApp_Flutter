import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_storage.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/simple_text_input.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = "CreateGroupScreen";
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? _image;
  bool loading = false;

  getImage() async {
    try {
      var tempImg = await pickImage();

      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      return alertUser(context: context, alertText: "error when getting image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Create Group",
          color: AppColors.whiteColor,
          size: 20,
        ),
      ),
      body: Column(
        children: [
          // all content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // group image
                  imagePickerPlaceholderComp(onTap: getImage, image: _image),

                  const SizedBox(height: 10),
                  // groupname
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: SimpleTextInput(
                      hintText: "group name",
                    ),
                  ),
                  const SizedBox(height: 10),

                  // group member
                  multipleAddInputComp(
                    hintText: "group members email",
                    onPressed: () {},
                  ),

                  const SizedBox(height: 20),
                  // Tags
                  multipleAddInputComp(
                    hintText: "#Tags",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "Create Group",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
