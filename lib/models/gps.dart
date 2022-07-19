// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class GPS {
  GPS({
    this.id,
    required this.state,
  });
  String? id;
  String state;

  factory GPS.fromJson(String str) => GPS.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GPS.fromMap(Map<String, dynamic> json) => GPS(
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "state": state,
      };
}

class WalkerGps {
  WalkerGps({
    this.idGps,
    required this.idWalker,
  });

  String? idGps;
  String idWalker;

  factory WalkerGps.fromJson(String str) => WalkerGps.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WalkerGps.fromMap(Map<String, dynamic> json) => WalkerGps(
        idGps: json["id_gps"],
        idWalker: json["id_walker"],
      );

  Map<String, dynamic> toMap() => {
        "id_gps": idGps,
        "id_walker": idWalker,
      };
}
