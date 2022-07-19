import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/models.dart';

class WalkService extends ChangeNotifier {
  final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';
  bool isLoading = true;
  bool isSaving = false;

  Future saveWalk(Walk walk, String idPet) async {
    isSaving = true;
    notifyListeners();
    if (walk.id == null) {
      await this.createWalk(walk);
      await this.createPetWalk(walk, idPet);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> createWalk(Walk walk) async {
    final url = Uri.https(_baseUrl, 'walk.json');
    final resp = await http.post(url, body: walk.toJson());
    final decodedDate = json.decode(resp.body);
    walk.id = decodedDate['name'];
    return walk.id!;
  }

  Future<String> createPetWalk(Walk walk, String idPet) async {
    final url = Uri.https(_baseUrl, 'pet_walk.json');

    final petWalk = PetWalks(idPet: idPet, idWalk: walk.id!);

    final resp = await http.post(url, body: petWalk.toJson());
    final decodedDate = json.decode(resp.body);

    return petWalk.idWalk;
  }
}
