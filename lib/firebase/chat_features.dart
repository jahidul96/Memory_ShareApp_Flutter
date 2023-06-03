// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoryapp/models/message_model.dart';

groupChat({
  required MessageModel msgData,
  required String groupId,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add(msgData.toMap());
  } catch (e) {
    print(e);
  }
}
