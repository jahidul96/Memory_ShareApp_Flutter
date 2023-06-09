import 'package:flutter/material.dart';
import 'package:memoryapp/screens/auth/add_pic.dart';
import 'package:memoryapp/screens/auth/login.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/custome_button.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:memoryapp/widgets/text_input_container.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  goToProfilePicScreen() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return alertUser(context: context, alertText: "Fill all the fields");
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPic(
            email: emailController.text,
            password: passwordController.text,
            username: usernameController.text,
          ),
        ));
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
              icon: Icons.person,
              hintText: "Username",
              inputController: usernameController,
            ),
            const SizedBox(height: 15),
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
            CustomButton(
              text: "NEXT",
              onPressed: () => goToProfilePicScreen(),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextComp(
                  text: "Have an account ?",
                  fontweight: FontWeight.normal,
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: TextComp(
                    text: "Login",
                    size: 17,
                    color: AppColors.appbarColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
