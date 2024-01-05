// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';
import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:eurokey2/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import "package:provider/provider.dart";

class EurolockProvider extends ChangeNotifier {
  late List<EUKLocationData> _locationsList;
  EUKLocationData? _currentEUK;
  String? _filterBy;
  List<Marker> _markers = [];
  MapController? mapController;

  List<EUKLocationData> get locationsList => _locationsList;

  EUKLocationData? get currentEUK => _currentEUK;
  set currentEUK(EUKLocationData? newEUK) {
    _currentEUK = newEUK;
    if (newEUK != null) {
      final zoom = mapController?.camera.zoom ?? 15;
      mapController?.move(newEUK.location, zoom);
    }
    notifyListeners();
  }

  List<Marker> get markers => _markers;
  set markers(List<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  void cleanupCurrentEUK() {
    _currentEUK = null;
  }

  String distanceToString(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      final distanceInKm = distance / 1000;
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }

  ListTile mapItemBuilder(BuildContext context, EUKLocationData loc) {
    final String distanceText = distanceToString(loc.distanceFromUser);

    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      title: Text(loc.address),
      subtitle: Text('${loc.city}, ${loc.zip}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.directions, color: Colors.blue),
          const SizedBox(height: 4),
          Text(distanceText),
        ],
      ),
      onTap: () async {
        MapsLauncher.launchCoordinates(loc.lat, loc.lng, loc.address);
      },
    );
  }

  ListTile itemBuilder(BuildContext context, EUKLocationData loc) {
    final String distanceFromUserText = distanceToString(loc.distanceFromUser);
    // final String distanceFromMapText = distanceToString(loc.distanceFromMap);
    final String distanceText;

    // if (distanceFromUserText == distanceFromMapText) {
    distanceText = distanceFromUserText;
    // } else {
    //  distanceText = "$distanceFromUserText ($distanceFromMapText)";
    // }

    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      title: Text(loc.address),
      subtitle: Text('${loc.city}, ${loc.zip}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getIconByType(loc.type),
          const SizedBox(height: 4),
          Text(distanceText),
        ],
      ),
      onTap: () {
        final locProvider =
            Provider.of<LocationProvider>(context, listen: false);

        locProvider.currentMapPosition = loc.location;

        currentEUK = loc;

        hideVirtualKeyboard();

        context.go("/main/1");
      },
    );
  }

  Future<List<EUKLocationData>> filterList(
    List<EUKLocationData> list,
    String search,
  ) async {
    return list.where((element) {
      return removeDiacritics(element.address.toLowerCase()).contains(search) ||
          removeDiacritics(element.city.toLowerCase()).contains(search) ||
          removeDiacritics(element.zip.toLowerCase()).contains(search);
    }).toList();
  }

  Future<List<EUKLocationData>> sortList(
    List<EUKLocationData> list,
    LatLng? userLocation,
    LatLng mapLocation,
  ) async {
    for (final loc in list) {
      loc.distanceFromMap = Geolocator.distanceBetween(
        mapLocation.latitude,
        mapLocation.longitude,
        loc.lat,
        loc.lng,
      );
      if (userLocation == null) {
        continue;
      }

      loc.distanceFromUser = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        loc.lat,
        loc.lng,
      );
    }

    list.sort((a, b) => a.distanceFromMap.compareTo(b.distanceFromMap));

    return list;
  }

  Future<List<Widget>> getList(
    BuildContext context,
    LatLng? userLocation,
    LatLng mapLocation,
  ) async {
    final List<EUKLocationData> list;
    if (_filterBy != null) {
      list = await sortList(
        await filterList(
          _locationsList,
          _filterBy!,
        ),
        userLocation,
        mapLocation,
      );
    } else {
      list = await sortList(
        _locationsList,
        userLocation,
        mapLocation,
      );
    }

    return list.map((location) => itemBuilder(context, location)).toList();
  }

  void onSearch(String value) {
    _filterBy = removeDiacritics(value.toLowerCase());
    notifyListeners();
  }

  void _initMarkers() {
    for (final euk in _locationsList) {
      _markers.add(euk.toMarker(this));
    }
  }

  Future<void> onInitApp() async {
    //const eurokliceLocationsURL =
    //  'https://www.euroklic.cz/element/simple/documents-to-download/8/3/9ce2559301112481.xlsx?download=true&download_filename=Pruvodce_po_mistech_v_CR_osazenych_Eurozamky_20231020_web.xlsx';

    // parse the on disk file
    final String fileData = await rootBundle.loadString('assets/data.json');

    final parsed = (jsonDecode(fileData) as List).cast<Map<String, dynamic>>();

    _locationsList = parsed
        .map<EUKLocationData>((json) => EUKLocationData.fromJson(json))
        .toList();

    _initMarkers();

    return;
  }
}
