
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Tracks users current position.
class UserPositionLocator {
  final Location _loc = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locData;
  final double zoomAmount = 15;
  final LatLng _defaultPos = const LatLng(50.073658, 14.418540);
  LatLng _currentPosition = const LatLng(0, 0);

  ///Initializes the location service.
  Future<void> initLocation() async {
    _serviceEnabled = await _loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _loc.requestService();
      if (!_serviceEnabled) {
        showSnackBar(message: 'Musíš aktivovat sledování polohy, aby aplikace mohla správně fungovat.');
        return;
      }
    }

    _permissionGranted = await _loc.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _loc.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnackBar(message: 'Musíš povolit aplikaci přístup k poloze, aby mohla správně fungovat.');
        return;
      }
    }

    _locData = await _loc.getLocation();
    _currentPosition = LatLng(_locData.latitude ?? _defaultPos.latitude, _locData.longitude ?? _defaultPos.longitude);
  }

  ///Updates the current position of the device.
  Future<void> updateLocation() async {
    _loc.onLocationChanged.listen((LocationData loc) {
      _currentPosition = LatLng(loc.latitude ?? _defaultPos.latitude, loc.longitude ?? _defaultPos.longitude);
    });
  }

  LatLng get currentPosition => _currentPosition;
}
