import 'package:flutter/material.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
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
      body: Column(
        children: [
          // all content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // group image
                  Center(
                    child: Container(
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

                  const SizedBox(height: 10),
                  // groupname
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "group name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // group member
                  multipleAddInputComp(
                    hintText: "group members email",
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "Create Group",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
