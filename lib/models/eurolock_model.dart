import 'dart:async';
import 'dart:convert';

import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/features/location_data/excel_loading/excel_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class EurolockModel extends ChangeNotifier {
  final _excelParser = ExcelParser();
  late List<EUKLocationData> locationsList;
  List<Widget> itemList = [];

  Container itemBuilder(EUKLocationData loc) {
    return Container(
      height: 50,
      color: Colors.amber[500],
      child: Center(child: Text(loc.address)),
    );
  }

  Future<Map<String, Marker>> getMarkers(LatLng location) async {
    final Map<String, Marker> markers = {};
    // if (locationsList.isEmpty) {
    await onInitApp();
    // }
    for (final loc in locationsList) {
      final marker = Marker(
        markerId: MarkerId(loc.id),
        position: LatLng(loc.lat, loc.long),
        infoWindow: InfoWindow(
          title: loc.address,
          snippet: loc.address,
        ),
      );
      markers[loc.id] = marker;
    }
    return markers;
  }

  Future<List<Widget>> sortList(LatLng location) async {
    if (locationsList.isEmpty) {
      await onInitApp();
    }

    for (final loc in locationsList) {
      loc.distanceFromDevice = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        loc.lat,
        loc.long,
      );
    }

    locationsList
        .sort((a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice));

    return locationsList.map((location) => itemBuilder(location)).toList();
  }

  void onSearch(String value) {
    // Prepare filtered list

    notifyListeners();
  }

  void buildItemList() {
    itemList = locationsList.map((location) => itemBuilder(location)).toList();
    notifyListeners();
  }

  Future<void> onInitApp() async {
    //const eurokliceLocationsURL =
    //  'https://www.euroklic.cz/element/simple/documents-to-download/8/3/9ce2559301112481.xlsx?download=true&download_filename=Pruvodce_po_mistech_v_CR_osazenych_Eurozamky_20231020_web.xlsx';

    const eurokliceLocationsURL =
        'https://github.com/ondrej66/RPR1/raw/main/Dokumenty/jiz_osazeno.xlsx';
    try {
      final response = await http.get(Uri.parse(eurokliceLocationsURL));

      if (response.statusCode == 200) {
        // parse the downloaded file
        locationsList = await _excelParser.parse(response.bodyBytes);
        buildItemList();
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // parse the on disk file
    final String fileData =
        await rootBundle.loadString('assets/jiz_osazeno.xlsx');

    locationsList = await _excelParser.parse(utf8.encode(fileData));
    buildItemList();
    return;
  }
}
