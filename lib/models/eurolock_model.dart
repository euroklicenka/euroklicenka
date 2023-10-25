import 'dart:async';
import 'dart:convert';

import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import "package:provider/provider.dart";

class EurolockModel extends ChangeNotifier {
  late List<EUKLocationData> locationsList;
  bool locationsListInitialized = false;
  EUKLocationData? _currentEUK;
  EUKLocationData? get currentEUK => _currentEUK;

  set currentEUK(EUKLocationData? newEUK) {
    _currentEUK = newEUK;
    notifyListeners();
  }

  ListTile mapItemBuilder(BuildContext context, EUKLocationData loc) {
    final distanceFromDevice = loc.distanceFromDevice;
    final String distanceText;

    if (distanceFromDevice < 1000) {
      distanceText = '${distanceFromDevice.toStringAsFixed(0)} m';
    } else {
      final distanceInKm = distanceFromDevice / 1000;
      distanceText = '${distanceInKm.toStringAsFixed(2)} km';
    }

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
    final distanceFromDevice = loc.distanceFromDevice;
    final String distanceText;

    if (distanceFromDevice < 1000) {
      distanceText = '${distanceFromDevice.toStringAsFixed(0)} m';
    } else {
      final distanceInKm = distanceFromDevice / 1000;
      distanceText = '${distanceInKm.toStringAsFixed(2)} km';
    }

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
        final locProvider = Provider.of<LocationModel>(context, listen: false);

        locProvider.currentPosition = loc.location;

        _currentEUK = loc;
        context.go("/map");

        notifyListeners();
      },
    );
  }

  Future<Map<String, Marker>> getMarkers(
    LatLng location,
  ) async {
    final Map<String, Marker> markers = {};

    await sortList(location);

    /* show only 10 nearest locations */
    var count = 20;
    for (final loc in locationsList) {
      final latlng = LatLng(loc.lat, loc.lng);

      final marker = Marker(
        markerId: MarkerId(loc.id),
        position: latlng,
        onTap: () {
          _currentEUK = loc;
        },
      );
      markers[loc.id] = marker;
      if (--count == 0) {
        //  break;
      }
    }
    return markers;
  }

  Future<void> sortList(LatLng location) async {
    for (final loc in locationsList) {
      loc.distanceFromDevice = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        loc.lat,
        loc.lng,
      );
    }

    locationsList
        .sort((a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice));
  }

  Future<List<Widget>> getList(BuildContext context, LatLng location) async {
    await sortList(location);

    return locationsList
        .map((location) => itemBuilder(context, location))
        .toList();
  }

  void onSearch(String value) {
    // Prepare filtered list

    notifyListeners();
  }

  Future<void> onInitApp() async {
    //const eurokliceLocationsURL =
    //  'https://www.euroklic.cz/element/simple/documents-to-download/8/3/9ce2559301112481.xlsx?download=true&download_filename=Pruvodce_po_mistech_v_CR_osazenych_Eurozamky_20231020_web.xlsx';

    if (locationsListInitialized) {
      return;
    }

    // parse the on disk file
    final String fileData = await rootBundle.loadString('assets/data.json');

    final parsed = (jsonDecode(fileData) as List).cast<Map<String, dynamic>>();

    locationsList = parsed
        .map<EUKLocationData>((json) => EUKLocationData.fromJson(json))
        .toList();

    locationsListInitialized = true;

    return;
  }
}
