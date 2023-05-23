import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  String text;
  double borderRadius;
  CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          minimumSize: const Size(double.infinity, 55),
        ),
        child: TextComp(
          text: text,
          color: AppColors.whiteColor,
          size: 20,
        ),
      ),
    );
  }
}
