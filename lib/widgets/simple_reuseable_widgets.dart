import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/models/group_info.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/simple_text_input.dart';
import 'package:memoryapp/widgets/loadder_widget.dart';

Widget groupNameAndMemberCounter({
  required String groupName,
  required String memberCount,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: AppColors.whiteColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextComp(
              text: groupName,
              size: 20,
            ),
            const SizedBox(height: 8),
            TextComp(
              text: "$memberCount member in the group",
              fontweight: FontWeight.normal,
              size: 18,
            ),
          ],
        ),
      ),
    );
Widget addMemberBtn(
        {required IconData iconData,
        required Function()? onTap,
        required String text}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 22,
            ),
            const SizedBox(
              width: 10,
            ),
            TextComp(
              text: text,
              size: 17,
            )
          ],
        ),
      ),
    );

Widget emailProfile({
  required String email,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.greyColor,
            ),
            child: Center(
              child: TextComp(
                text: email.substring(0, 1).toUpperCase(),
                color: AppColors.whiteColor,
                size: 15,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextComp(
              text: email.length > 15 ? "${email.substring(0, 14)}..." : email,
              fontweight: FontWeight.normal,
              size: 15,
            ),
          ),
          // widget.groupInfo.adminId == FirebaseAuth.instance.currentUser!.uid
          //     ? TextComp(
          //         text: "owner",
          //         fontweight: FontWeight.normal,
          //         color: AppColors.greyColor,
          //       )
          //     : Container(),
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
                    child: CachedNetworkImage(
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      imageUrl: groupInfo.groupProfilePic,
                      placeholder: (context, url) => const Center(
                        child: Icon(
                          Icons.image,
                          size: 30,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 30,
                      ),
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
                        : "Friends",
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
                loadderWidget(),
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
