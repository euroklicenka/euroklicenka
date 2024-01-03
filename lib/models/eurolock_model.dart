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
    final String distanceFromMapText = distanceToString(loc.distanceFromMap);
    final String distanceText;

    if (distanceFromUserText == distanceFromMapText) {
      distanceText = distanceFromUserText;
    } else {
      distanceText = "$distanceFromUserText ($distanceFromMapText)";
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

        locProvider.currentMapPosition = loc.location;

        currentEUK = loc;

        hideVirtualKeyboard();

        context.go("/main/1");
      },
    );
  }

  Future<MapEntry<String, Marker>> markerBuilder(
    ImageConfiguration imageConfiguration,
    EUKLocationData euk,
  ) async {
    final icon = await getMarkerIconByType(imageConfiguration, euk.type);

    return MapEntry(
      euk.id,
      Marker(
        markerId: MarkerId(euk.id),
        position: LatLng(euk.lat, euk.lng),
        onTap: () {
          currentEUK = euk;
        },
        icon: icon,
      ),
    );
  }

  Future<Map<String, Marker>> getMarkers(BuildContext context) async {
    final List<MapEntry<String, Marker>> entries = [];
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);

    for (final euk in _locationsList) {
      // we cannot use fromEntries() directly because of await
      entries.add(await markerBuilder(imageConfiguration, euk));
    }

    return Map<String, Marker>.fromEntries(entries);
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
    // FIXME: Recalculate only on map location change
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

      // FIXME: Recalculate only on user location change
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
