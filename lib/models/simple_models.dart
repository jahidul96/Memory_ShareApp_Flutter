import 'dart:convert';

class GroupNotificationModel {
  String name;
  String type;
  GroupNotificationModel({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
    };
  }

  factory GroupNotificationModel.fromMap(Map<String, dynamic> map) {
    return GroupNotificationModel(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupNotificationModel.fromJson(String source) =>
      GroupNotificationModel.fromMap(json.decode(source));
}
