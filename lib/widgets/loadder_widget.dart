import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadderWidget() => Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: AppColors.appbarColor,
        size: 40,
      ),
    );
