import 'dart:async';
import 'dart:ui';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/location_manager.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusteredEUKLocationManager extends EUKLocationManager {
  late ClusterManager<EUKLocationData> _clusterManager;

  // _locations, // Your items to be clustered on the map (of Place type for this example)
  // _updateMarkers, // Method to be called when markers are updated
  //  markerBuilder: _markerBuilder(), // Optional : Method to implement if you want to customize markers
  //  levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0], // Optional : Configure this if you want to change zoom levels at which the clustering precision change
  //  extraPercent: 0.2, // Optional : This number represents the percentage (0.2 for 20%) of latitude and longitude (in each direction) to be considered on top of the visible map bounds to render clusters. This way, clusters don't "pop out" when you cross the map.
  //  stopClusteringZoom: 17.0 // Optional : The zoom level to stop clustering, so it's only rendering single item "clusters"

  final StreamController<Set<Marker>> _markerStreamController =
      StreamController<Set<Marker>>.broadcast();

  ClusteredEUKLocationManager() : super();

  Set<Marker> get _markers => super.markers;

  Stream<Set<Marker>> get markerStream => _markerStreamController.stream;

  List<EUKLocationData> get _locations => super.locations;

  void initClusterManager() {
    _clusterManager = ClusterManager<EUKLocationData>(
      <EUKLocationData>[],
      _updateMarkers,
      markerBuilder: _markerBuilder,
      // initialZoom: 12,
      stopClusteringZoom: 16,
    );
  }

  @override
  Future<void> reloadFromDatabase() async {
    await super.reloadFromDatabase();
    _clusterManager.setItems(_locations);
    _clusterManager.updateMap();
    _buildMarkers();
  }

  Future<void> _buildMarkers() async {
    _markers.clear();

    final List<Cluster<EUKLocationData>> clusters =
        _clusterManager.getMarkers() as List<Cluster<EUKLocationData>>;
    final List<Marker> markers = [];

    // Create a list of marker futures
    final markerFutures = clusters.map((cluster) async {
      final LatLng latLng = cluster.location;
      final int count = cluster.count;

      if (count == 1) {
        final EUKLocationData location = cluster.items.first;
        return await convertToMarker(location, windowController);
      } else {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            windowController.addInfoWindow!(
              buildPopUpWindow(cluster.items.first),
              LatLng(latLng.latitude, latLng.longitude),
            );
          },
        );
      }
    });

    // Wait for all marker futures to complete
    final completedMarkers = await Future.wait(markerFutures);

    markers.addAll(completedMarkers);
    _markerStreamController.add(markers.toSet());
  }

  ///test marketbuilder na clustering
  Future<Marker> Function(Cluster<EUKLocationData>) get _markerBuilder =>
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

  ///test customize icons with clustering
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

// @override
// void initState() {
//   _manager = _initClusterManager();
//   super.initState();
// }
//
// ClusterManager _initClusterManager() {
//   return ClusterManager<EUKLocationData>(_locations, _updateMarkers,
//       markerBuilder: _markerBuilder);
// }
//
void _updateMarkers(Set<Marker> markers) {
  print('Updated ${markers.length} markers');
  // setState(() {
  //   this.markers = markers;
  // });
}

//
// /// uprava metody na clustering marek, jen zkouska
// Future<BitmapDescriptor> _getMarkerBitmap(int size, EUKLocationType type) async {
//   if (kIsWeb) size = (size / 2).floor();
//
//   final PictureRecorder pictureRecorder = PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);
//
//   switch (type) {
//     case EUKLocationType.none:
//       canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.deepOrangeAccent);
//       break;
//     case EUKLocationType.wc:
//       canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.blue);
//       break;
//     case EUKLocationType.platform:
//       canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.red);
//       break;
//     case EUKLocationType.hospital:
//       canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, Paint()..color = Colors.green);
//       break;
//   }
//
//   final img = await pictureRecorder.endRecording().toImage(size, size);
//   final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
//
//   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
// }
