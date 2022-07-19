import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingMapScreen extends StatefulWidget {
  static String routeName = 'tracking';

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  //  final Future<GoogleMapController> _controller;
  //TODO: HACERLO CON COMPLETER
  late final GoogleMapController _controller;
  List<LatLng> polylinesCoordinates = [];

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.0660055);

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });

    //TODO: HACERLO CON COMPLETER
    GoogleMapController googleMapController = _controller;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );
      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyB-sdTO2zXzDh0L4Z5tQZjhdun2CsDG-Ro",
      PointLatLng(sourceLocation.latitude, sourceLocation.latitude),
      PointLatLng(destination.latitude, destination.latitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylinesCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
      setState(() {});
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "/Users/macbookair/AndroidProjects/flutter-productos-app-fin-seccion-12/assets/nala copy.jpg")
        .then((icon) => sourceIcon = icon);
    //TODO: ARREGLAR ESTO
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "/Users/macbookair/AndroidProjects/flutter-productos-app-fin-seccion-12/assets/nala copy.jpg")
        .then((icon) => sourceIcon = icon);
    //TODO: ARREGLAR ESTO
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "/Users/macbookair/AndroidProjects/flutter-productos-app-fin-seccion-12/assets/nala copy.jpg")
        .then((icon) => sourceIcon = icon);
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traking'),
      ),
      body: currentLocation == null
          ? Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylinesCoordinates,
                  color: Colors.deepPurple,
                  width: 6,
                ),
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 12.5,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("currentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  icon: sourceIcon,
                ),
                Marker(
                  markerId: MarkerId("source"),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                ),
              },
              onMapCreated: (map) {
                //TODO: ver de hacer un completer
                _controller = map;
              }),
    );
  }
}
