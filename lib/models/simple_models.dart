import 'dart:convert';

class GroupInfo {
  String groupId;
  String groupName;
  String groupProfilePic;
  String adminId;
  GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.groupProfilePic,
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupProfilePic': groupProfilePic,
      'adminId': adminId,
    };
  }

  factory GroupInfo.fromMap(Map<String, dynamic> map) {
    return GroupInfo(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupProfilePic: map['groupProfilePic'] ?? '',
      adminId: map['adminId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupInfo.fromJson(String source) =>
      GroupInfo.fromMap(json.decode(source));
}
