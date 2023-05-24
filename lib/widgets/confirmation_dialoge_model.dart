import 'package:flutter/material.dart';
import 'package:memoryapp/widgets/custome_button.dart';

import '../utils/app_colors.dart';
import 'text_comp.dart';

Future alertUser({
  required BuildContext context,
  required String alertText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: TextComp(
          text: alertText,
          color: AppColors.black,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
            ),
            child: TextComp(
              text: "Ok",
              color: AppColors.whiteColor,
            ),
          ),
        ],
      );
    },
  );
}

Future confirmModel({
  required BuildContext context,
  required Function()? confirmFunc,
  required String infoText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(infoText),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
              ),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: confirmFunc,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appbarColor,
              ),
              child: const Text("Ok")),
        ],
      );
    },
  );
}
