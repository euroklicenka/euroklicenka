import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/excel_loading/excel_parser.dart';
import 'package:euk2_project/features/location_data/excel_loading/http_loader.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  final String locationsURL = 'https://www.euroklic.cz/element/simple/documents-to-download/4/0/ccff3b38583129f3.xlsx?download=true&download_filename=Pr%C5%AFvodce+po+m%C3%ADstech+%C4%8CR+osazen%C3%BDch+Euroz%C3%A1mky.xlsx';
  final BehaviorSubject<Set<Marker>> _markerStream = BehaviorSubject<Set<Marker>>();

  late UserDataManager _dataManager;
  late HTTPLoader _HTTPloader;
  late ClusterManager _clusterManager;
  late ExcelParser _excelParser;
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;

  EUKLocationManager({required UserDataManager dataManager}) {
    _dataManager = dataManager;
    _HTTPloader = HTTPLoader();
    _excelParser = ExcelParser();
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};
  }

  ///Disposes of the Popup Window.
  void dispose() {
    _windowController.dispose();
  }

  ///Loads EUK Locations from the built-in URL link and stores them
  ///in the internal list.
  Future<void> reloadFromDatabase() async {
    final List<int> bytes = await _HTTPloader.getAsBytes(locationsURL);
    final List<EUKLocationData> locations = await _excelParser.parse(bytes);
    _locations = locations;
    _buildMarkers();

    _dataManager.saveEUKLocationData(locations);
  }

  ///Loads EUK Locations from the current device.
  ///If no save data is found, tries to load data from the internet.
  void reloadFromLocalStorage() {
    _locations.clear();
    _locations = _dataManager.loadEUKLocationData();

    if (_locations.isEmpty) {
      reloadFromDatabase();
      return;
    }
    _buildMarkers();
  }

  ///Builds are markers based data from [_locations].
  Future<void> _buildMarkers() async {
    _markers.clear();
    _initClusterManager();

    for (final EUKLocationData loc in _locations) {
      _markers.add(Marker(markerId: MarkerId(loc.id), position: loc.location));
    }
  }

  ///Initializes the cluster manager.
  void _initClusterManager() {
    _clusterManager = ClusterManager<EUKLocationData>(_locations, _updateMarkers, markerBuilder: getMarkerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    _markers = markers;
    _markerStream.sink.add(_markers);
  }

  /// A method, who's responsibility is to create new map markers, based on
  /// clusters, that need to be built.
  ///
  /// Uses custom icons for individual markers and cluster icons for clusters.
  Future<Marker>Function(Cluster<EUKLocationData>)? get getMarkerBuilder => (cluster) async {
    final BitmapDescriptor icon = (cluster.isMultiple) ? await getClusterIcon(150, text:cluster.count.toString()) : await getMarkerIconByType(cluster.items.first.type);
    final Function() onTap = (cluster.isMultiple) ? (){} : (){
      final EUKLocationData data = cluster.items.first;
      windowController.addInfoWindow!(buildPopUpWindow(data), LatLng(data.lat, data.long));
    };

    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      onTap: onTap,
      icon: icon,
    );
  };

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;

  Set<Marker> get markers => _markers;

  Stream<Set<Marker>> get markerStream => _markerStream;

  CustomInfoWindowController get windowController => _windowController;

  ClusterManager get clusterManager => _clusterManager;










}

