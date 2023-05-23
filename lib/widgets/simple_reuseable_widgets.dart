import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

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

Widget groupListTile() => InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            const Icon(
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
                  TextComp(text: "Share"),
                  TextComp(
                    text: "From you",
                    fontweight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    );
