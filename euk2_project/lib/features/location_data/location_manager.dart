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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  final String locationsURL =
      'https://www.euroklic.cz/element/simple/documents-to-download/4/0/ccff3b38583129f3.xlsx?download=true&download_filename=Pr%C5%AFvodce+po+m%C3%ADstech+%C4%8CR+osazen%C3%BDch+Euroz%C3%A1mky.xlsx';
  final BehaviorSubject<Set<Marker>> _markerStream =
      BehaviorSubject<Set<Marker>>();

  late HTTPLoader _HTTPloader;
  late ExcelParser _excelParser;
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;
  late ClusterManager _clusterManager;

  EUKLocationManager() {
    _HTTPloader = HTTPLoader();
    _excelParser = ExcelParser();
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};
    _clusterManager = ClusterManager<EUKLocationData>(
        _locations,
        // Your items to be clustered on the map (of Place type for this example)
        _updateMarkers, // Method to be called when markers are updated
        markerBuilder: _markerBuilder,
        // Optional : Method to implement if you want to customize markers
        levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
        // Optional : Configure this if you want to change zoom levels at which the clustering precision change
        extraPercent: 0.2,
        // Optional : This number represents the percentage (0.2 for 20%) of latitude and longitude (in each direction) to be considered on top of the visible map bounds to render clusters. This way, clusters don't "pop out" when you cross the map.
        stopClusteringZoom:
            17.0 // Optional : The zoom level to stop clustering, so it's only rendering single item "clusters"
        );
  }

  void _updateMarkers(Set<Marker> markers) {
    //setState(() {
    _markers.clear();
    _markers.addAll(markers);
    // });
  }

  Future<Marker> Function(Cluster<EUKLocationData>) get _markerBuilder =>
          (cluster) async {
        final markerList = <Marker>[];
        for (final EUKLocationData loc in cluster.items) {
          final childMarker = await convertToMarker(loc, windowController);
          markerList.add(childMarker);
        }
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await getMarkerIconByType(cluster.items.first.type),
          // set the parent marker ID for all child markers
          infoWindow: InfoWindow(
            snippet: 'Child markers: ${markerList.length}',
          ),
          // don't show the parent marker on the map
          consumeTapEvents: true,
          visible: false,
          // set the parent marker ID as the child markers' anchor
          anchor: Offset(0.5, 0.5),
        );
      };


  /// uprava metody na clustering marek, jen zkouska
  Future<BitmapDescriptor> _getMarkerBitmap(int size, EUKLocationType type) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    switch (type) {
      case EUKLocationType.none:
        canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.deepOrangeAccent);
        break;
      case EUKLocationType.wc:
        canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.blue);
        break;
      case EUKLocationType.platform:
        canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.red);
        break;
      case EUKLocationType.hospital:
        canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.green);
        break;
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
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
  }

  Future<void> _buildMarkers() async {
    _markers.clear();

    for (final EUKLocationData loc in _locations) {
      _markers.add(await convertToMarker(loc, windowController));
      _markerStream.sink.add(_markers);
    }
  }

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;

  Set<Marker> get markers => _markers;

  Stream<Set<Marker>> get markerStream => _markerStream;

  CustomInfoWindowController get windowController => _windowController;
}
