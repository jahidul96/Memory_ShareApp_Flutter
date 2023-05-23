import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/text_comp.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextComp(
          text: "Account",
          color: AppColors.whiteColor,
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 60,
                  ),
                  const SizedBox(height: 5),
                  TextComp(
                    text: "Jahidul",
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  TextComp(
                    text: "Jahidul@gmail.com",
                    fontweight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Divider(height: 5),
            optionComp(text: "Update profile picture"),
            optionComp(text: "Groups"),
            optionComp(text: "Password & security"),
            optionComp(text: "Delete my account"),
            optionComp(text: "Log out"),
          ],
        ),
      ),
    );
  }

  Widget optionComp({
    required String text,
  }) =>
      InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextComp(
                  text: text,
                  size: 18,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
}
