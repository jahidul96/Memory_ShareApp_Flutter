import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/auth_fb.dart';
import 'package:memoryapp/screens/auth/register.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/simple_reuseable_widgets.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/text_input_container.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return alertUser(context: context, alertText: "Fill All The Fields");
    }

    setState(() {
      loading = true;
    });
    Timer(const Duration(seconds: 4), () {
      loginUser(emailController.text, passwordController.text, context);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFf2f2f2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextComp(
                text: "Memory App",
                size: 30,
              ),
            ),
            const SizedBox(height: 30),
            ContainerTextInput(
              icon: Icons.email,
              hintText: "Email",
              inputController: emailController,
            ),
            const SizedBox(height: 15),
            ContainerTextInput(
              icon: Icons.lock,
              hintText: "Password",
              inputController: passwordController,
              secure: true,
            ),
            const SizedBox(height: 25),
            // lodder component
            sendinglodingComp(
              loading: loading,
              loadderText: "Loggin wait...",
              btnText: "LOGIN",
              onPressed: () => login(),
            ),
            // CustomButton(
            //   text: "LOGIN",
            //   onPressed: () => login(),
            // ),
            const SizedBox(height: 15),

            loading
                ? Container()
                : Column(
                    children: [
                      Center(
                        child: TextComp(
                          text: "Forgot Password ?",
                          fontweight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextComp(
                            text: "Don't Have an account ?",
                            fontweight: FontWeight.normal,
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: TextComp(
                              text: "SignUp",
                              size: 17,
                              color: AppColors.appbarColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
