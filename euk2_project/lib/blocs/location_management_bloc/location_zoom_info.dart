import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///A data container for information needed for camera zooming.
class LocationZoomInfo {
  LatLng? wantedPosition;
  double? wantedZoom;
  Widget? popupWindow;

  ///Clears all stored data.
  void clear() {
    wantedPosition = null;
    wantedZoom = null;
    popupWindow = null;
  }
}