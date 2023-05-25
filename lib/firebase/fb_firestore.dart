// ignore_for_file: file_names

import 'package:memoryapp/firebase/fb_instance.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
