import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:memoryapp/screens/auth/register.dart';
import 'package:memoryapp/screens/home.dart';

class AuthCheckScreen extends StatelessWidget {
  static const routeName = "authcheck";
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const RegisterScreen();
          }
        },
      ),
    );
  }
}
