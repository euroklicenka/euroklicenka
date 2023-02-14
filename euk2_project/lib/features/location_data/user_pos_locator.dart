
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Tracks users current position.
class UserPositionLocator {
  final Location _loc = Location();
  final double zoomAmount = 15;
  LatLng _currentPosition = const LatLng(0, 0);

  Future<void> updateLocation() async {
    _loc.onLocationChanged.listen((LocationData loc) {
      _currentPosition = LatLng(loc.latitude ?? 0, loc.longitude ?? 0);
    });
  }

  LatLng get currentPosition => _currentPosition;
}
