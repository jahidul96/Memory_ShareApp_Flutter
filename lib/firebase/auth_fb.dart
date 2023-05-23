import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoryapp/screens/auth/auth_check.dart';
import 'package:memoryapp/firebase/fb_instance.dart';

void registerUser(
    {required String username,
    required String email,
    required String password,
    required String profileUrl,
    required BuildContext context}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    Map<String, dynamic> userData = {
      "username": username.toLowerCase(),
      "email": email.toLowerCase(),
      "id": credential.user!.uid,
      "profilePic": profileUrl,
      "bio": "hey there i am using chatapp!"
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc(credential.user!.uid)
        .set(userData)
        .then(
      (value) {
        Navigator.pushNamed(context, AuthCheckScreen.routeName);
      },
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
    } else if (e.code == 'email-already-in-use') {}
  }
}

void loginUser(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((_) => {Navigator.pushNamed(context, AuthCheckScreen.routeName)});
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
    } else if (e.code == 'wrong-password') {}
  }
}

// get myData
Future getMyData() async {
  try {
    var data = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return data.data();
  } catch (e) {
    print("some error");
  }
}
