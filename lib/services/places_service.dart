import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';

class PlacesService {
  final String _scheme = 'https';
  final String _key = 'AIzaSyB-sdTO2zXzDh0L4Z5tQZjhdun2CsDG-Ro';
  final String _baseUrl = 'maps.googleapis.com';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    // Uri url =
    //     'maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&language=es&types=address&key=$key';
    var httpsUri = Uri(
        scheme: _scheme,
        host: _baseUrl,
        path: '/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': search,
          'language': 'es',
          'types': 'address',
          'key': _key
        });

    var response = await http.get(httpsUri);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromMap(place)).toList();
  }

  Future<Place> getPlace(String id) async {
    // Uri url =
    //     'maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&language=es&types=address&key=$key';
    var httpsUri = Uri(
        scheme: _scheme,
        host: _baseUrl,
        path: '/maps/api/place/details/json',
        queryParameters: {'place_id': id, 'key': _key});

    var response = await http.get(httpsUri);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
