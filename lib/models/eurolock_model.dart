import 'dart:async';
import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import "package:provider/provider.dart";

class EurolockModel extends ChangeNotifier {
  late List<EUKLocationData> _locationsList;
  EUKLocationData? _currentEUK;
  EUKLocationData? get currentEUK => _currentEUK;
  String? _filterBy;

  set currentEUK(EUKLocationData? newEUK) {
    _currentEUK = newEUK;
    notifyListeners();
  }

  void cleanupCurrentEUK() {
    _currentEUK = null;
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

        currentEUK = loc;

        hideVirtualKeyboard();

        context.go("/main/1");
      },
    );
  }

  MapEntry<String, Marker> markerBuilder(EUKLocationData euk) {
    return MapEntry(
      euk.id,
      Marker(
        markerId: MarkerId(euk.id),
        position: LatLng(euk.lat, euk.lng),
        onTap: () {
          currentEUK = euk;
        },
      ),
    );
  }

  Future<Map<String, Marker>> getMarkers() async {
    return Map<String, Marker>.fromEntries(
      _locationsList.map((euk) => markerBuilder(euk)),
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
    LatLng location,
  ) async {
    for (final loc in list) {
      loc.distanceFromDevice = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        loc.lat,
        loc.lng,
      );
    }

    list.sort((a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice));

    return list;
  }

  Future<List<Widget>> getList(BuildContext context, LatLng location) async {
    final List<EUKLocationData> list;
    if (_filterBy != null) {
      list = await sortList(
        await filterList(
          _locationsList,
          _filterBy!,
        ),
        location,
      );
    } else {
      list = await sortList(
        _locationsList,
        location,
      );
    }

    return list.map((location) => itemBuilder(context, location)).toList();
  }

  void onSearch(String value) {
    _filterBy = removeDiacritics(value.toLowerCase());
    notifyListeners();
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

    return;
  }
}
