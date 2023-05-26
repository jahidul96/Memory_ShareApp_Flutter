import 'dart:convert';

class UserModel {
  String profilePic;
  String id;
  String email;
  String username;

  UserModel(
      {required this.profilePic,
      required this.id,
      required this.email,
      required this.username});

  Map<String, dynamic> toMap() {
    return {
      'profilePic': profilePic,
      'id': id,
      'email': email,
      'username': username,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      profilePic: map['profilePic'] ?? '',
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
