import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:flutter/material.dart';

///Returns an [Icon], representing the given location [type].
Icon getIconByType(EUKLocationType type) {
  switch (type) {
    case EUKLocationType.none:
      return const Icon(
        Icons.lock,
        color: Colors.deepOrangeAccent,
        size: 28,
      );
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
    case EUKLocationType.gate:
      return const Icon(
        Icons.door_sliding,
        color: Colors.teal,
        size: 28,
      );
    case EUKLocationType.elevator:
      return const Icon(
        Icons.elevator,
        color: Colors.black38,
        size: 28,
      );
  }
}

Future<void> precacheMarkerIcon(BuildContext context) async {
  precacheImage(
    const AssetImage("markers/map_marker_default.png"),
    context,
  );
  precacheImage(
    const AssetImage("markers/map_marker_wc.png"),
    context,
  );
  precacheImage(
    const AssetImage("markers/map_marker_platform.png"),
    context,
  );
  precacheImage(
    const AssetImage("markers/map_marker_gate.png"),
    context,
  );
  precacheImage(
    const AssetImage("markers/map_marker_elevator.png"),
    context,
  );
}

///Returns a custom marker icon, based on an EUK location type.
Image getMarkerIconByType(
  EUKLocationType type,
) {
  final String assetName = switch (type) {
    EUKLocationType.none => "markers/map_marker_default.png",
    EUKLocationType.wc => "markers/map_marker_wc.png",
    EUKLocationType.platform => "markers/map_marker_platform.png",
    EUKLocationType.gate => "markers/map_marker_gate.png",
    EUKLocationType.elevator => "markers/map_marker_elevator.png",
  };

  return Image.asset(assetName);
}
