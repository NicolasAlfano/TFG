// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:productos_app/models/models.dart';

class Walker {
  Walker(
      {this.id,
      required this.idPersons,
      this.location,
      this.qualification,
      this.services,
      this.gps});
  String? id;
  String idPersons;
  String? location;
  int? qualification;

  List<PetService>? services;
  List<GPS>? gps;

  factory Walker.fromJson(String str) => Walker.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Walker.fromMap(Map<String, dynamic> json) => Walker(
        idPersons: json["id_persons"],
        location: json["location"],
        qualification: json["qualification"],
      );

  Map<String, dynamic> toMap() => {
        "id_persons": idPersons,
        "location": location,
        "qualification": qualification,
      };
}

// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

class WalkerService {
  WalkerService({
    this.idServices,
    this.idWalkers,
  });

  String? idServices;
  String? idWalkers;

  factory WalkerService.fromJson(String str) =>
      WalkerService.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WalkerService.fromMap(Map<String, dynamic> json) => WalkerService(
        idServices: json["id_services"],
        idWalkers: json["id_walkers"],
      );

  Map<String, dynamic> toMap() => {
        "id_services": idServices,
        "id_walkers": idWalkers,
      };
}
