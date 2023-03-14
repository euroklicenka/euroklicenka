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
    _initClusterManager();
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
    _buildClusters();

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
    _buildClusters();
  }

  Future<void> _buildClusters() async {
    _markers.clear();
    _initClusterManager();

    for (final EUKLocationData loc in _locations) {
      _markers.add(await convertToMarker(loc, windowController));
    }
  }

  void _initClusterManager() {
    _clusterManager = ClusterManager<EUKLocationData>(_locations, _updateMarkers, markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    _markers = markers;
    _markerStream.sink.add(_markers);
  }

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;

  Set<Marker> get markers => _markers;

  Stream<Set<Marker>> get markerStream => _markerStream;

  CustomInfoWindowController get windowController => _windowController;

  ClusterManager get clusterManager => _clusterManager;








  Future<Marker>Function(Cluster<EUKLocationData>)? get _markerBuilder =>
          (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

}

