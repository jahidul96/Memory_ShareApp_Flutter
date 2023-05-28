import 'dart:convert';

class CommentModel {
  String commentterId;
  String commentText;
  DateTime commentTime;
  CommentModel({
    required this.commentterId,
    required this.commentText,
    required this.commentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentterId': commentterId,
      'commentText': commentText,
      'commentTime': commentTime.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentterId: map['commentterId'] ?? '',
      commentText: map['commentText'] ?? '',
      commentTime: DateTime.fromMillisecondsSinceEpoch(map['commentTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
