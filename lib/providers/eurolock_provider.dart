// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';
import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import "package:provider/provider.dart";
import 'package:intl/intl.dart';

const List<String> countries = ["cz", "sk"];

class EurolockProvider extends ChangeNotifier {
  late List<EUKLocationData> _locationsList;
  late DateTime _lastModified;
  EUKLocationData? _currentEUK;
  String? _filterBy;
  List<Marker> _markers = [];
  MapController? mapController;

  DateTime get lastModified => _lastModified;

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

  Widget placeText(EUKLocationData loc) {
    final List<Widget> l = [];

    l.add(Text(loc.place, style: const TextStyle(fontWeight: FontWeight.bold)));
    if (loc.street != '') {
      l.add(Text(loc.street));
    }
    l.add(Text('${loc.zip} ${loc.city}'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: l,
    );
  }

  String navigateButtonText() => Intl.message(
        'NAVIGOVAT',
        name: 'EurolockProvider_navigateButtonText',
      );

  Widget navigateButton(EUKLocationData loc) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text(navigateButtonText()),
          onPressed: () async {
            MapsLauncher.launchCoordinates(
              loc.lat,
              loc.lng,
              loc.place,
            );
          },
        ),
      ],
    );
  }

  String distanceTextMessage() => Intl.message(
        'Vzdálenost: ',
        name: 'EurolockProvider_distanceText',
      );

  Widget mapItemBuilder(BuildContext context, EUKLocationData loc) {
    final String distanceText = distanceToString(loc.distanceFromUser);

    return ListTile(
      title: placeText(loc),
      subtitle: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: distanceTextMessage(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: distanceText),
          ],
        ),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getIconByType(loc.type),
        ],
      ),
      onTap: () async {
        MapsLauncher.launchCoordinates(
          loc.lat,
          loc.lng,
          loc.place,
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context, EUKLocationData loc) {
    final String distanceText = distanceToString(loc.distanceFromMap);

    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: placeText(loc),
        leading: getIconByType(loc.type),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.chevron_right),
            const SizedBox(height: 4),
            Text(distanceText),
          ],
        ),
        onTap: () {
          final locationProvider =
              Provider.of<LocationProvider>(context, listen: false);
          final sharedPreferencesProvider =
              Provider.of<PreferencesProvider>(context, listen: false);

          locationProvider.currentMapPosition = loc.location;

          currentEUK = loc;

          hideVirtualKeyboard();

          sharedPreferencesProvider.mainScreenState =
              MainScreenStates.mapScreenState;
        },
      ),
    );
  }

  Future<List<EUKLocationData>> filterList(
    List<EUKLocationData> list,
    String search,
  ) async {
    return list.where((element) {
      return removeDiacritics(element.place.toLowerCase()).contains(search) ||
          removeDiacritics(element.street.toLowerCase()).contains(search) ||
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

  String getUrl(String country) {
    return "https://cdn.euroklicenka.cz/data-$country.json";
  }

  Future<void> sync(bool force) async {
    if (force) {
      DefaultCacheManager().emptyCache();
      _locationsList = [];
    }

    List<EUKLocationData> newLocationsList = [];
    for (String country in countries) {
      final url = getUrl(country);

      showSnackBar(message: "Loading $url");

      final cachedFile = await DefaultCacheManager().getSingleFile(url);

      final fileData = await cachedFile.readAsString();

      _lastModified = await cachedFile.lastModified();

      final jsonData = await jsonDecode(fileData);

      final parsed = (jsonData as List).cast<Map<String, dynamic>>();

      final list = parsed
          .map<EUKLocationData>((json) => EUKLocationData.fromJson(json))
          .toList();

      newLocationsList.addAll(list);
    }

    _locationsList = newLocationsList;

    _initMarkers();
  }

  Future<void> onInitApp() async {
    // parse the on disk file

    for (String country in countries) {
      final url = getUrl(country);
      final name = 'assets/data-$country.json';
      final fileData = await rootBundle.load(name);
      final fileList = Uint8List.view(fileData.buffer);

      showSnackBar(message: "Storing $name to $url");

      DefaultCacheManager()
          .putFile(url, fileList, maxAge: const Duration(days: 1));
    }

    await sync(false);

    return;
  }
}
