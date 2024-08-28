// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _currentUserPosition;
  double _currentMapZoom = 14.5;
  LatLng _currentMapPosition = const LatLng(49.840281, 18.288796);

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

  Future<void> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      // showSnackBar(message: "Location services disabled.");
      return;
    }

    switch (await Geolocator.checkPermission()) {
      case LocationPermission.deniedForever:
        // showSnackBar(message: "Location services denied forever.");
        return;
      case LocationPermission.denied:
        // showSnackBar(message: "Location services denied.");
        return;
      default:
        final Position position = await Geolocator.getCurrentPosition();

        // showSnackBar(message: "Location: ${position.latitude}, ${position.longitude}.");

        _currentUserPosition = LatLng(position.latitude, position.longitude);
        _currentMapPosition = LatLng(position.latitude, position.longitude);
    }
  }
}
