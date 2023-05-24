import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/custome_button.dart';

Future profilePicBottomSheet({
  required BuildContext context,
  required double height,
  required Function()? pickImage,
  required File? image,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 30),
            InkWell(
              onTap: pickImage,
              child: Center(
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          image,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(text: "SIGN UP", onPressed: () {}),
            )
          ],
        ),
      );
    },
  );
}
