
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Tracks users current position.
class UserPositionLocator {

  final LatLng defaultPos = const LatLng(50.073658, 15.4);
  final Location _loc = Location();
  final double _zoomAmount = 15;

  late bool _serviceEnabled;
  LocationData? _locData;
  LatLng _currentPosition = const LatLng(0, 0);

  ///Initializes the location service.
  Future<void> initLocation() async {
    try {
      _serviceEnabled = await _loc.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _loc.requestService();
        if (!_serviceEnabled) {
          showSnackBar(message: 'Musíš aktivovat sledování polohy, aby aplikace mohla správně fungovat.');
        }
      }
      _locData = await _loc.getLocation();
    } on PlatformException {
      showSnackBar(message: 'Musíš povolit aplikaci přístup k poloze, aby mohla správně fungovat.');
    }

    _currentPosition = LatLng(_locData?.latitude ?? defaultPos.latitude, _locData?.longitude ?? defaultPos.longitude);
  }

  ///Updates the current position of the device.
  Future<void> updateLocation() async {
    _loc.onLocationChanged.listen((LocationData loc) {
      _currentPosition = LatLng(loc.latitude ?? defaultPos.latitude, loc.longitude ?? defaultPos.longitude);
    });
  }

  ///Returns TRUE if current position is the same as teh default one.
  bool isSameAsDefaultPos() => currentPosition == defaultPos;

  LatLng get currentPosition => _currentPosition;
  double get zoomAmount => (currentPosition == defaultPos) ? 6.25 : _zoomAmount;
}
