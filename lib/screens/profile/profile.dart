// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/profile/edit_profile_info.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/screens/auth/auth_check.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // confirm logout
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      user.profilePic != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                user.profilePic,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                            ),
                      const SizedBox(height: 7),
                      TextComp(
                        text: user.username.toUpperCase(),
                        size: 18,
                      ),
                      const SizedBox(height: 3),
                      TextComp(
                        text: user.email,
                        fontweight: FontWeight.normal,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(height: 3),
                optionComp(
                  text: "Edit profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileInfo(),
                      ),
                    );
                  },
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
          );
        },
      ),
    );
  }

// optioncomp widget
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
