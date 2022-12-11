import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/data/euk_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Converts [EUKLocationData] into Google Maps [Marker] data.
Future<Set<Marker>> convertToMarkers(List<EUKLocationData> data, CustomInfoWindowController windowController) async {
  final Set<Marker> markers = {};

  for (final EUKLocationData location in data) {
    markers.add(
      await EUKMarker.create(
        id: markers.length.toString(),
        data: location,
        windowController: windowController,
      ),
    );
  }

  return markers;
}
