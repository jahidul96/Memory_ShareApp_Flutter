import 'dart:convert';

class GroupInfo {
  String groupId;
  String groupName;
  String groupProfilePic;
  String adminId;
  int notificationCounter;
  GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.groupProfilePic,
    required this.adminId,
    required this.notificationCounter,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupProfilePic': groupProfilePic,
      'adminId': adminId,
      'notificationCounter': notificationCounter,
    };
  }

  factory GroupInfo.fromMap(Map<String, dynamic> map) {
    return GroupInfo(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupProfilePic: map['groupProfilePic'] ?? '',
      adminId: map['adminId'] ?? '',
      notificationCounter: map['notificationCounter']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupInfo.fromJson(String source) =>
      GroupInfo.fromMap(json.decode(source));
}
