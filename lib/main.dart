import 'package:flutter/material.dart';
import 'package:memoryapp/screens/auth/register.dart';
import 'package:memoryapp/screens/auth/login.dart';
import 'package:memoryapp/screens/group/create_group.dart';
import 'package:memoryapp/screens/group/single_group_details.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/screens/post.dart';
import 'package:memoryapp/screens/profile.dart';

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
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        SingleGroupDeatail.routeName: (context) => const SingleGroupDeatail(),
        CreateGroupScreen.routeName: (context) => const CreateGroupScreen(),
        PostScreen.routeName: (context) => const PostScreen(),
      },
      home: const RegisterScreen(),
    );
  }
}
