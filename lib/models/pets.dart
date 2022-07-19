// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:productos_app/models/models.dart';

class Pet {
  Pet(
      {this.id,
      required this.breed,
      required this.gender,
      this.gpsAssigned,
      required this.name,
      required this.photo,
      required this.year,
      this.service});

  String? id;
  String breed;
  String gender;
  String? gpsAssigned;
  String name;
  String photo;
  int year;
  PetService? service;

  factory Pet.fromJson(String str) => Pet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pet.fromMap(Map<String, dynamic> json) => Pet(
        breed: json["breed"],
        gender: json["gender"],
        gpsAssigned: json["gps_assigned"],
        name: json["name"],
        photo: json["photo"],
        year: json["year"],
      );

  Map<String, dynamic> toMap() => {
        "breed": breed,
        "gender": gender,
        "gps_assigned": gpsAssigned,
        "name": name,
        "photo": photo,
        "year": year,
      };

  Pet copy(PetService serv) => Pet(
      id: this.id,
      breed: this.breed,
      gender: this.gender,
      gpsAssigned: this.gpsAssigned,
      name: this.name,
      photo: this.photo,
      year: this.year,
      service: serv);
}
