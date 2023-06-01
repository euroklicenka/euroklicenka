import 'dart:async';

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Tracks users current position.
class UserPositionLocator {
  final LatLng defaultPos = const LatLng(50.073658, 15.4);

  final double _zoomAmount = 15;
  LatLng _currentPosition = const LatLng(0, 0);
  LocationAccuracyStatus _accuracyStatus = LocationAccuracyStatus.unknown;

  Future<void> activate() async {
    _currentPosition = await _getDevicePosition();
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) async {
      _currentPosition = LatLng(position?.latitude ?? defaultPos.latitude, position?.longitude ?? defaultPos.longitude);
      _accuracyStatus = await Geolocator.getLocationAccuracy();
    });
  }

  ///Get the position of the device in [LatLng].
  Future<LatLng> _getDevicePosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(message: 'Musíš aktivovat sledování polohy, aby aplikace mohla správně fungovat.');
      return defaultPos;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        showSnackBar(message: 'Musíš povolit aplikaci přístup k poloze, aby mohla správně fungovat.');
        return defaultPos;
      }
    }

    final Position pos = await Geolocator.getCurrentPosition();
    return LatLng(pos.latitude, pos.longitude);
  }

  LatLng get currentPosition => _currentPosition;
  double get zoomAmount => (currentPosition == defaultPos) ? 6.25 : _zoomAmount;
  LocationAccuracyStatus get accuracyStatus => _accuracyStatus;
}
