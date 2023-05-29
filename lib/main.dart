import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memoryapp/provider/user_provider.dart';
import 'package:memoryapp/screens/auth/auth_check.dart';
import 'package:memoryapp/screens/auth/register.dart';
import 'package:memoryapp/screens/auth/login.dart';
import 'package:memoryapp/screens/group/create_group.dart';
import 'package:memoryapp/screens/home.dart';
import 'package:memoryapp/screens/profile/profile.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Memory App',
        theme: ThemeData.light(),
        routes: {
          AuthCheckScreen.routeName: (context) => const AuthCheckScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          CreateGroupScreen.routeName: (context) => const CreateGroupScreen(),
        },
        home: const AuthCheckScreen(),
      ),
    );
  }
}
