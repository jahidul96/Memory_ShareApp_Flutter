import 'dart:convert';

class GroupModel {
  String groupProfilePic;
  String groupName;
  List<String> groupMember;
  List<String> tags;
  DateTime createdAt;
  String adminId;
  GroupModel({
    required this.groupProfilePic,
    required this.groupName,
    required this.groupMember,
    required this.tags,
    required this.createdAt,
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupProfilePic': groupProfilePic,
      'groupName': groupName,
      'groupMember': groupMember,
      'tags': tags,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'adminId': adminId,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupProfilePic: map['groupProfilePic'] ?? '',
      groupName: map['groupName'] ?? '',
      groupMember: List<String>.from(map['groupMember']),
      tags: List<String>.from(map['tags']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      adminId: map['adminId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));
}
