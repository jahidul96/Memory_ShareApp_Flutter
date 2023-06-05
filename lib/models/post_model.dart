import 'dart:convert';

class PostModel {
  List<String> postImages;
  String groupName;
  List<String> likes;
  String posterId;
  String description;
  String groupId;
  DateTime postedAt;
  PostModel({
    required this.postImages,
    required this.groupName,
    required this.likes,
    required this.posterId,
    required this.description,
    required this.groupId,
    required this.postedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postImages': postImages,
      'groupName': groupName,
      'likes': likes,
      'posterId': posterId,
      'description': description,
      'groupId': groupId,
      'postedAt': postedAt.millisecondsSinceEpoch,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postImages: List<String>.from(map['postImages']),
      groupName: map['groupName'] ?? '',
      likes: List<String>.from(map['likes']),
      posterId: map['posterId'] ?? '',
      description: map['description'] ?? '',
      groupId: map['groupId'] ?? '',
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
