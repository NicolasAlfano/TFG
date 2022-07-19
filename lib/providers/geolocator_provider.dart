import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/services/services.dart';

//PATRON BLOC
//with == extends ??
class GeolocatorProvider extends ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  // StreamController<Place> selectedLocation = StreamController<Place>();
  Place? _selectedLocation;

  late Position currentLocation;
  late List<PlaceSearch> searchResult = [];

  GeolocatorProvider() {
    // this.setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrenLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResult = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  //copia del metodo de arriba pero no notifica listeners
  Future<List<PlaceSearch>> searchListPlaces(String searchTerm) async {
    return searchResult = await placesService.getAutocomplete(searchTerm);
  }

  // setSelectedLocation(String placeId) async {
  //   selectedLocation.add(await placesService.getPlace(placeId));
  //   searchResult = [];
  //   notifyListeners();
  // }
//remplaza al metodo de arriba
  setSelectedPlace(String placeId) async {
    searchResult = [];
    this._selectedLocation = await placesService.getPlace(placeId);
    notifyListeners();
  }

  String getSelectedPlaceName() {
    if (_selectedLocation != null) {
      return this._selectedLocation!.name;
    }
    return '';
  }

  String getSelectedVicinity() {
    if (_selectedLocation != null) {
      if (_selectedLocation!.vicinity != '') {
        return this._selectedLocation!.vicinity!;
      }
    }
    return '';
  }

  @override
  void dispose() {
    // selectedLocation.close();
    super.dispose();
  }
}
