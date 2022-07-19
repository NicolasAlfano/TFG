// To parse this JSON data, do
//
//     final placeSearch = placeSearchFromMap(jsonString);

import 'dart:convert';

class Person {
  Person({
    required this.dni,
    required this.idUser,
    required this.lastName,
    required this.name,
  });

  factory Person.fromJson(String str) => Person.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  String? id;
  int dni;
  String idUser;
  String lastName;
  String name;

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        dni: json["dni"],
        idUser: json["id_user"],
        lastName: json["last_name"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "dni": dni,
        "id_user": idUser,
        "last_name": lastName,
        "name": name,
      };
}
