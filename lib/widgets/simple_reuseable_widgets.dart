import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/models/simple_models.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/simple_text_input.dart';

Widget groupNameAndMemberCounter() => Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: AppColors.whiteColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextComp(
              text: "GroupName",
              size: 20,
            ),
            const SizedBox(height: 8),
            TextComp(
              text: "2 member in the group",
              fontweight: FontWeight.normal,
              size: 18,
            ),
          ],
        ),
      ),
    );
Widget addMemberBtn() => Row(
      children: [
        const Icon(
          Icons.add,
          size: 30,
        ),
        TextComp(
          text: "Add Members",
          size: 20,
        )
      ],
    );

Widget emailProfile() => Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.greyColor,
            ),
            child: Center(
              child: TextComp(
                text: "J",
                color: AppColors.whiteColor,
                size: 17,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComp(text: "Jahidul"),
              const SizedBox(height: 2),
              TextComp(
                text: "Jahidul@gmail.com",
                fontweight: FontWeight.normal,
                size: 15,
              ),
            ],
          )
        ],
      ),
    );

Widget groupListTile({
  required GroupInfo groupInfo,
  required Function()? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            groupInfo.groupProfilePic != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      groupInfo.groupProfilePic,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 30,
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComp(
                      text: groupInfo.groupName != ""
                          ? groupInfo.groupName
                          : "groupname"),
                  TextComp(
                    text: FirebaseAuth.instance.currentUser!.uid ==
                            groupInfo.adminId
                        ? "From you"
                        : "",
                    fontweight: FontWeight.normal,
                    size: 13,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    );

Widget multipleAddInputComp({
  required String hintText,
  required Function()? onPressed,
  required TextEditingController controller,
}) => // group member
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: SimpleTextInput(
              controller: controller,
              hintText: hintText,
            ),
          ),
          const SizedBox(width: 15),
          CustomButton(
            text: "Add",
            textSize: 17,
            onPressed: onPressed,
            width: 80,
            height: 40,
          ),
        ],
      ),
    );

Widget imagePickerPlaceholderComp({
  required Function()? onTap,
  required File? image,
}) =>
    InkWell(
      onTap: onTap,
      child: Center(
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: AppColors.appbarColor,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
      ),
    );

Widget sendinglodingComp({
  required bool loading,
  required Function()? onPressed,
  required String loadderText,
  required String btnText,
}) =>
    loading
        ? Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                TextComp(text: loadderText)
              ],
            ),
          )
        : CustomButton(
            text: btnText,
            onPressed: onPressed,
          );

// showCase item comp
Widget showCaseItemComp(
        {required String itemText, required Function()? onTap}) =>
    Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Center(
            child: TextComp(
              text: itemText.length > 12
                  ? "${itemText.substring(0, 12)}..."
                  : itemText,
              size: 14,
              fontweight: FontWeight.normal,
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.close,
                  size: 17,
                  color: AppColors.buttonColor,
                ),
              ))
        ],
      ),
    );
