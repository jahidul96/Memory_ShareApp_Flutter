import 'dart:convert';

import 'package:memoryapp/models/user_model.dart';

class CommentModel {
  UserModel commentterInfo;
  String commentText;
  DateTime commentTime;
  CommentModel({
    required this.commentterInfo,
    required this.commentText,
    required this.commentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentterInfo': commentterInfo.toMap(),
      'commentText': commentText,
      'commentTime': commentTime.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentterInfo: UserModel.fromMap(map['commentterInfo']),
      commentText: map['commentText'] ?? '',
      commentTime: DateTime.fromMillisecondsSinceEpoch(map['commentTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
