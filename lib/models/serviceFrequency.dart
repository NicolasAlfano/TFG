// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class ServiceFrequency {
  ServiceFrequency({
    this.id,
    this.idService,
    required this.friday,
    required this.monday,
    required this.thursday,
    required this.tuesday,
    required this.wednesday,
  });
  String? id;
  bool friday;
  String? idService;
  bool monday;
  bool thursday;
  bool tuesday;
  bool wednesday;

  factory ServiceFrequency.fromJson(String str) =>
      ServiceFrequency.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiceFrequency.fromMap(Map<String, dynamic> json) =>
      ServiceFrequency(
        friday: json["friday"],
        idService: json["id_service"],
        monday: json["monday"],
        thursday: json["thursday"],
        tuesday: json["tuesday"],
        wednesday: json["wednesday"],
      );

  Map<String, dynamic> toMap() => {
        "friday": friday,
        "id_service": idService,
        "monday": monday,
        "thursday": thursday,
        "tuesday": tuesday,
        "wednesday": wednesday,
      };
}

enum Day { monday, tuesday, wednesday, thursday, friday }
