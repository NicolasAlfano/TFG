import 'dart:convert';

import '../models/models.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GPSService extends ChangeNotifier {
  final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';

  Walker? selectedWalker;
  bool isLoading = true;
  bool isSaving = false;

  Future<List<GPS>> loadGPS() async {
    List<GPS> gps = [];

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'gps.json');
    final resp = await http.get(url);

    final Map<String, dynamic> petsMap = json.decode(resp.body);

    petsMap.forEach((key, value) {
      final tempPet = GPS.fromMap(value);
      tempPet.id = key;
      gps.add(tempPet);
    });

    selectedWalker!.gps = gps;

    this.isLoading = false;
    notifyListeners();

    return selectedWalker!.gps!;
  }
}
