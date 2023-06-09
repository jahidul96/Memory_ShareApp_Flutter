import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';

class ContainerTextInput extends StatelessWidget {
  TextEditingController inputController;
  IconData icon;
  String hintText;
  bool secure;

  ContainerTextInput(
      {super.key,
      required this.icon,
      required this.hintText,
      required this.inputController,
      this.secure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 7),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.greyColor,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                obscureText: secure,
                controller: inputController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: AppColors.greyColor),
                  hintText: hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
