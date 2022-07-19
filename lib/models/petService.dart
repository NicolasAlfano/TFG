// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:productos_app/models/serviceFrequency.dart';

class PetService {
  PetService(
      {this.id,
      required this.address,
      required this.minutes,
      this.startTime,
      this.endTime,
      required this.idFrequency,
      required this.idPet,
      required this.isGroup,
      required this.qualification,
      this.rideType,
      this.typology,
      this.zone,
      this.vicinity,
      this.frequency});
  String? id;
  String address;
  int minutes;
  String? startTime;
  String? endTime;
  String idFrequency;
  String idPet;
  bool isGroup;
  double qualification;
  String? rideType;
  String? typology;
  String? zone;
  String? vicinity;
  ServiceFrequency? frequency;
  String? nameWalker;

  factory PetService.fromJson(String str) =>
      PetService.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PetService.fromMap(Map<String, dynamic> json) => PetService(
        address: json["address"],
        minutes: json["duration"],
        endTime: json["end_time"],
        idFrequency: json["id_frequency"],
        idPet: json["id_pet"],
        isGroup: json["is_group"],
        qualification: json["qualification"].toDouble(),
        rideType: json["ride_type"],
        startTime: json["start_time"],
        typology: json["typology"],
        zone: json["zone"],
        vicinity: json["vicinity"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "duration": minutes,
        "end_time": endTime,
        "id_frequency": idFrequency,
        "id_pet": idPet,
        "is_group": isGroup,
        "qualification": qualification,
        "ride_type": rideType,
        "start_time": startTime,
        "typology": typology,
        "zone": zone,
        "vicinity": vicinity
      };

  PetService copy(ServiceFrequency frequency) => PetService(
      id: this.id,
      address: this.address,
      minutes: this.minutes,
      startTime: this.startTime,
      endTime: this.endTime,
      idFrequency: this.idFrequency,
      idPet: this.idPet,
      isGroup: this.isGroup,
      qualification: this.qualification,
      rideType: this.rideType,
      typology: this.typology,
      zone: this.zone,
      vicinity: this.vicinity,
      frequency: frequency);

  Duration duration() {
    if (minutes < 30) {
      return Duration(minutes: 30);
    }
    return Duration(minutes: minutes);
  }

  String ride() {
    if (rideType.toString() == "C") {
      return "Con Correa";
    } else if (rideType.toString() == "M") {
      return "Mixto";
    }
    return "Libre";
  }

  String day() {
    if (typology.toString() == "T") {
      return "Tarde";
    }
    return "Mañana";
  }

  String description() {
    var days = daysCount();
    if (startTime!.contains('AM')) {
      return "Paseo Matutino de " + days + ' días';
    }
    return "Paseo vespertino de " + days + ' días';
  }

  String daysDescription = '';
  String daysCount() {
    int days = 0;
    if (frequency != null) {
      if (this.frequency!.monday) {
        days += 1;
        daysDescription = 'Lu-';
      }
      if (this.frequency!.tuesday) {
        days += 1;
        daysDescription += 'Ma-';
      }
      if (this.frequency!.wednesday) {
        days += 1;
        daysDescription += 'Mi-';
      }
      if (this.frequency!.thursday) {
        days += 1;
        daysDescription += 'Ju-';
      }
      if (this.frequency!.friday) {
        days += 1;
        daysDescription += 'Vi';
      }
    }

    return days.toString();
  }

  String typologyAndRideType() {
    var type = ride();
    if (isGroup) {
      return 'Paseo grupal ' + type;
    }
    return 'Paseo individual ' + type;
  }

  String hoursDescription() {
    return this.startTime.toString() + ' a ' + this.endTime.toString();
  }
}
