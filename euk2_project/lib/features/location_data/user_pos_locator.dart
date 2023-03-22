
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Tracks users current position.
class UserPositionLocator {
  final Location _loc = Location();
  final double zoomAmount = 15;
  final LatLng _defaultPos = const LatLng(50.073658, 14.418540);

  late bool _serviceEnabled;
  LocationData? _locData;
  LatLng _currentPosition = const LatLng(0, 0);

  ///Initializes the location service.
  Future<void> initLocation() async {
    _serviceEnabled = await _loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _loc.requestService();
      if (!_serviceEnabled) {
        showSnackBar(message: 'Musíš aktivovat sledování polohy, aby aplikace mohla správně fungovat.');
      }
    }

    try {
      _locData = await _loc.getLocation();
    } on PlatformException {
      showSnackBar(message: 'Musíš povolit aplikaci přístup k poloze, aby mohla správně fungovat.');
    }

    _currentPosition = LatLng(_locData?.latitude ?? _defaultPos.latitude, _locData?.longitude ?? _defaultPos.longitude);
  }

  ///Updates the current position of the device.
  Future<void> updateLocation() async {
    _loc.onLocationChanged.listen((LocationData loc) {
      _currentPosition = LatLng(loc.latitude ?? _defaultPos.latitude, loc.longitude ?? _defaultPos.longitude);
    });
  }

  LatLng get currentPosition => _currentPosition;
}
