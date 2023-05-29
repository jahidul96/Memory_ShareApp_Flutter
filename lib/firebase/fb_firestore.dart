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
        .update(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Data update problem");
  }
}

// update user info
likeFbPost({
  required data,
  required BuildContext context,
  required String docId,
}) async {
  try {
    FirebaseFirestore.instance.collection("allposts").doc(docId).update(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Data update problem");
  }
}

// create a new group
addingDataInFbCollection({
  required data,
  required BuildContext context,
  required String collectionName,
  required String errorText,
}) {
  try {
    FirebaseFirestore.instance.collection(collectionName).add(data);
  } catch (e) {
    return alertUser(context: context, alertText: errorText);
  }
}

// comment
addCommentFb({
  required data,
  required BuildContext context,
  required String docId,
  required String errorText,
}) {
  try {
    FirebaseFirestore.instance
        .collection("allposts")
        .doc(docId)
        .collection("comments")
        .add(data);
  } catch (e) {
    return alertUser(context: context, alertText: errorText);
  }
}

// updateCommentCount
updateCommentCount({
  required data,
  required BuildContext context,
  required String docId,
}) async {
  try {
    FirebaseFirestore.instance.collection("allposts").doc(docId).update(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Data update problem");
  }
}

// updateCommentCount
editGroupFb({
  required data,
  required BuildContext context,
  required String docId,
}) async {
  try {
    FirebaseFirestore.instance.collection("groups").doc(docId).update(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Data update problem");
  }
}
