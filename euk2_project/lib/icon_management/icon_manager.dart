import 'dart:ui';

import 'package:euk2_project/locations/location_data_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getMarkerIconByType(TestLocationType type) async {
  Uint8List icon;
  const int size = 100;

  switch (type) {
    case TestLocationType.wc:
      icon = await getBytesFromAsset("assets/images/map_marker_wc.png", size);
      break;
    case TestLocationType.platform:
      icon = await getBytesFromAsset("assets/images/map_marker_wc.png", size);
      break;
    case TestLocationType.hospital:
      icon = await getBytesFromAsset("assets/images/map_marker_wc.png", size);
      break;
  }

  return BitmapDescriptor.fromBytes(icon);
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  final ByteData data = await rootBundle.load(path);
  final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  final FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
}

///Returns an icon, representing the given location type.
Icon getIconByType(TestLocationType type) {
  switch (type) {
    case TestLocationType.wc:
      return const Icon(
        Icons.wc,
        color: Colors.blue,
        size: 28,
      );
    case TestLocationType.platform:
      return const Icon(
        Icons.accessible_sharp,
        color: Colors.red,
        size: 28,
      );
    case TestLocationType.hospital:
      return const Icon(
        Icons.local_hospital,
        color: Colors.green,
        size: 28,
      );
  }
}
