// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/firebase/fb_instance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';

// get myData
Future getMyData() async {
  try {
    var data = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return data.data();
  } catch (e) {
    return e;
  }
}

// update user info
updateUserInfoFb({
  required data,
  required BuildContext context,
}) async {
  try {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Data update problem");
  }
}

// create a new group

createGroupInFb({
  required data,
  required BuildContext context,
}) {
  try {
    FirebaseFirestore.instance.collection("groups").add(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Creating group problem");
  }
}
