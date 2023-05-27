import 'dart:convert';

class GroupNameAndId {
  String groupId;
  String groupName;
  GroupNameAndId({
    required this.groupId,
    required this.groupName,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
    };
  }

  factory GroupNameAndId.fromMap(Map<String, dynamic> map) {
    return GroupNameAndId(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupNameAndId.fromJson(String source) =>
      GroupNameAndId.fromMap(json.decode(source));
}
