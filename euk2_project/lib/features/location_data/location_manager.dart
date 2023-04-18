import 'dart:io';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/internet_access/allowed_urls.dart';
import 'package:euk2_project/features/internet_access/http_communicator.dart';
import 'package:euk2_project/features/location_data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/excel_loading/excel_parser.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  final BehaviorSubject<Set<Marker>> _markerStream =
      BehaviorSubject<Set<Marker>>();

  late UserDataManager _dataManager;
  late ClusterManager _clusterManager;
  late ExcelParser _excelParser;
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;

  bool _hasThrownError = false;

  EUKLocationManager({required UserDataManager dataManager}) {
    _dataManager = dataManager;
    _excelParser = ExcelParser();
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};
    _initClusterManager();
  }

  ///Disposes of the Popup Window.
  void dispose() {
    _windowController.dispose();
  }

  ///Loads EUK Locations from the built-in URL link and stores them
  ///in the internal list.
  Future<void> reloadFromDatabase({Function()? onFinish}) async {
    _hasThrownError = false;

    try {
      final List<int> bytes = await getAsBytes(url: EUKDownloadURL);
      final List<EUKLocationData> locations = await _excelParser.parse(bytes);
      _locations = locations;
      _buildMarkers();
      _dataManager.saveEUKLocationData(locations);
    } on SocketException {
      _hasThrownError = true;
    }
    onFinish?.call();
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
  void _buildMarkers() {
    _markers.clear();
    _initClusterManager();

    for (final EUKLocationData loc in _locations) {
      _markers.add(Marker(markerId: MarkerId(loc.id), position: loc.location));
    }
  }

  ///Initializes the cluster manager.
  void _initClusterManager() {
    _clusterManager = ClusterManager<EUKLocationData>(
        _locations, _updateMarkers,
        markerBuilder: getMarkerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    _markers = markers;
    _markerStream.sink.add(_markers);
  }

  /// A method, who's responsibility is to create new map markers, based on
  /// clusters, that need to be built.
  ///
  /// Uses custom icons for individual markers and cluster icons for clusters.
  Future<Marker> Function(Cluster<EUKLocationData>)? get getMarkerBuilder =>
      (cluster) async {
        final BitmapDescriptor icon = (cluster.isMultiple)
            ? await getClusterIcon(270, text: cluster.count.toString())
            : await getMarkerIconByType(cluster.items.first.type);
        final Function() onTap = (cluster.isMultiple)
            ? () {}
            : () {
                final EUKLocationData data = cluster.items.first;
                windowController.addInfoWindow!(
                    buildPopUpWindow(data), LatLng(data.lat, data.long));
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
  bool get hasThrownError => _hasThrownError;
}
