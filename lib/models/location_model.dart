import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel with ChangeNotifier {
  LatLng _currentPosition = const LatLng(0, 0);
  final geolocator = Geolocator();
  StreamSubscription<Position>? positionStream;

  // Get the current position
  LatLng get currentPosition => _currentPosition;

  set currentPosition(LatLng newPosition) {
    _currentPosition = newPosition;
    notifyListeners();
  }

  Future<void> onSearch(String value) async {
    notifyListeners();
  }

  Future<void> onInitApp() async {
    _currentPosition = await _determinePosition();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position == null) {
          return;
        }

        double distance = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance > 100.0) {
          _currentPosition = LatLng(position.latitude, position.longitude);
          notifyListeners();
        }
      },
    );
  }

  Future<LatLng> _determinePosition() async {
    // Test if location services are enabled.

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final Position position = await Geolocator.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }
}
