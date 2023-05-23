import 'package:flutter/material.dart';
import 'package:memoryapp/screens/auth/register.dart';
import 'package:memoryapp/screens/auth/login.dart';
import 'package:memoryapp/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
      home: const RegisterScreen(),
    );
  }
}
