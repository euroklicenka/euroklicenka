import 'dart:ui';

import 'package:euk2_project/location_data/test_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Returns an icon, representing the given location type.
Icon getIconByType(EUKLocationType type) {
  switch (type) {
    case EUKLocationType.wc:
      return const Icon(
        Icons.wc,
        color: Colors.blue,
        size: 28,
      );
    case EUKLocationType.platform:
      return const Icon(
        Icons.accessible_sharp,
        color: Colors.red,
        size: 28,
      );
    case EUKLocationType.hospital:
      return const Icon(
        Icons.local_hospital,
        color: Colors.green,
        size: 28,
      );
  }
}

///Returns a custom marker icon, based on an EUK location type.
Future<BitmapDescriptor> getMarkerIconByType(EUKLocationType type) async {
  Uint8List icon;
  const int size = 110;

  switch (type) {
    case EUKLocationType.wc:
      icon = await _getBytesFromAsset("assets/images/map_marker_wc.png", size);
      break;
    case EUKLocationType.platform:
      icon = await _getBytesFromAsset("assets/images/map_marker_platform.png", size);
      break;
    case EUKLocationType.hospital:
      icon = await _getBytesFromAsset("assets/images/map_marker_hospital.png", size);
      break;
  }

  return BitmapDescriptor.fromBytes(icon);
}

Future<Uint8List> _getBytesFromAsset(String path, int width) async {
  final ByteData data = await rootBundle.load(path);
  final Codec codec = await instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png,))!.buffer.asUint8List();
}

