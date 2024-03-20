// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _currentUserPosition;
  double _currentMapZoom = 14.5;
  LatLng _currentMapPosition = const LatLng(0, 0);

  AlignOnUpdate _followOnLocationUpdate = AlignOnUpdate.once;
  final StreamController<double?> followCurrentLocationStreamController =
      StreamController<double?>();

  AlignOnUpdate get followOnLocationUpdate => _followOnLocationUpdate;
  set followOnLocationUpdate(AlignOnUpdate update) {
    _followOnLocationUpdate = update;
    notifyListeners();
  }

  double get currentMapZoom => _currentMapZoom;
  set currentMapZoom(double zoom) {
    _currentMapZoom = zoom;
    notifyListeners();
  }

  // Get the current position
  LatLng? get currentUserPosition => _currentUserPosition;
  set currentUserPosition(LatLng? position) {
    _currentUserPosition = position;
    notifyListeners();
  }

  LatLng get currentMapPosition => _currentMapPosition;
  set currentMapPosition(LatLng position) {
    _currentMapPosition = position;
    notifyListeners();
  }

  Future<void> onSearch(String value) async {
    notifyListeners();
  }

  Future<void> handlePermissions() async {
    // Test if location services are enabled.

    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  Future<void> getCurrentPosition() async {
    await handlePermissions();

    final Position position = await Geolocator.getCurrentPosition();

    _currentUserPosition = LatLng(position.latitude, position.longitude);
    _currentMapPosition = LatLng(position.latitude, position.longitude);
  }
}
