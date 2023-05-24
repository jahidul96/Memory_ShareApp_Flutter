import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/screens/auth/auth_check.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  logout() {
    confirmModel(
        context: context,
        confirmFunc: () => confirmLogout(),
        infoText: "You Want to logout");
  }

  confirmLogout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, AuthCheckScreen.routeName);
  }

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
            optionComp(
              text: "Update profile picture",
              onTap: () {},
            ),
            optionComp(text: "Groups", onTap: () {}),
            optionComp(text: "Password & security", onTap: () {}),
            optionComp(text: "Delete my account", onTap: () {}),
            optionComp(
                text: "Log out",
                onTap: () => confirmModel(
                    context: context,
                    confirmFunc: () => confirmLogout(),
                    infoText: "Sure you want to logout ?")),
          ],
        ),
      ),
    );
  }

  Widget optionComp({
    required String text,
    required Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
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
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
}
