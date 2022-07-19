import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getCurrenLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
