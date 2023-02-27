import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Converts [EUKLocationData] into Google Maps [Marker] data.
Future<Set<Marker>> convertToMarkers(List<EUKLocationData> dataList, CustomInfoWindowController windowController) async {
  final Set<Marker> markers = {};

  for (final EUKLocationData data in dataList) {
    markers.add(await _buildMarker(data, windowController));
  }

  return markers;
}

///Builds a [EUKPopupWindow] from [EUKLocationData] and returns it.
Widget buildPopUpWindow(EUKLocationData data) {
  return EUKPopupWindow(
    address: data.address,
    region: data.region,
    city: data.city,
    info: data.info,
    ZIP: data.ZIP,
    imageURL:
        //TODO Replace or Remove once we know how we are going to put in pictures.
        'http://polar.cz/data/gallery/modules/polar/news/articles/videos/20200319151335_301/715x402.jpg?ver=20200319151525',
  );
}

///Builds a new EUK Location map marker.
Future<Marker> _buildMarker(EUKLocationData data, CustomInfoWindowController windowController) async {
  final BitmapDescriptor icon = await getMarkerIconByType(data.type);
  return Marker(
    markerId: MarkerId(data.id),
    icon: icon,
    position: LatLng(data.lat, data.long),
    onTap: () => windowController.addInfoWindow!(buildPopUpWindow(data), LatLng(data.lat, data.long)),
  );
}
