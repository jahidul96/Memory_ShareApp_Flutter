import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  String text;
  double borderRadius;
  double width;
  double height;
  double textSize;
  CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width = double.infinity,
      this.textSize = 20,
      this.height = 55,
      this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          minimumSize: Size(width, height),
        ),
        child: TextComp(
          text: text,
          color: AppColors.whiteColor,
          size: textSize,
        ),
      ),
    );
  }
}
