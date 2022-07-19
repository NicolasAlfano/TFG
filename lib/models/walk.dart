import 'dart:convert';

class Walk {
  Walk({
    this.id,
    required this.state,
  });
  String? id;
  //TODO: INICIAL,BUSCANDO,EMPAREJANDO,PASEANDO, REGRESANDO
  String state;

  factory Walk.fromJson(String str) => Walk.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Walk.fromMap(Map<String, dynamic> json) => Walk(
        id: json["id_walk"],
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "id_walk": id,
        "state": state,
      };
}

class PetWalks {
  PetWalks({
    required this.idPet,
    required this.idWalk,
  });

  String idPet;
  String idWalk;

  factory PetWalks.fromJson(String str) => PetWalks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PetWalks.fromMap(Map<String, dynamic> json) => PetWalks(
        idPet: json["id_pet"],
        idWalk: json["id_walk"],
      );

  Map<String, dynamic> toMap() => {
        "id_pet": idPet,
        "id_walk": idWalk,
      };
}
