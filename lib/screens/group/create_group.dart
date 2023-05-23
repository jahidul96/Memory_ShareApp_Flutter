import 'package:flutter/material.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/utils/app_colors.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = "CreateGroupScreen";
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
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
    );
  }
}
