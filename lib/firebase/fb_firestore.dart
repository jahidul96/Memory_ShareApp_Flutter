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
addNewGroup({
  required data,
  required BuildContext context,
}) {
  try {
    FirebaseFirestore.instance.collection("groups").add(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Something went wrong!");
  }
}

addPost({
  required data,
  required BuildContext context,
}) {
  try {
    FirebaseFirestore.instance.collection("allposts").add(data);
  } catch (e) {
    return alertUser(context: context, alertText: "Something went wrong!");
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

// delete group post comments
deletePostComment(String groupId) async {
  var data = await FirebaseFirestore.instance
      .collection("allposts")
      .where("groupId", isEqualTo: groupId)
      .get();

  for (var doc in data.docs) {
    FirebaseFirestore.instance
        .collection("allposts")
        .doc(doc.id)
        .collection("comments")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var commentDoc in querySnapshot.docs) {
        FirebaseFirestore.instance
            .collection("allposts")
            .doc(doc.id)
            .collection("comments")
            .doc(commentDoc.id)
            .delete();
      }
    });
  }
}

// searchAllPost of a group and delete
deleteThisGroupPost(
  String groupId,
) async {
  var allpost = await FirebaseFirestore.instance
      .collection("allposts")
      .where("groupId", isEqualTo: groupId)
      .get();
  for (var doc in allpost.docs) {
    await FirebaseFirestore.instance
        .collection("allposts")
        .doc(doc.id)
        .delete();
  }
}

// delete whole group
deleteGroupFb(String id) async {
  await FirebaseFirestore.instance.collection("groups").doc(id).delete();
}
