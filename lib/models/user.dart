// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'dart:convert';

class User {
  User({
    required this.nickName,
    required this.password,
  });

  String nickName;
  int password;
  String? id;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        nickName: json["nick_name"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "nick_name": nickName,
        "password": password,
      };
}
