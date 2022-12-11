import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/data/euk_marker.dart';
import 'package:euk2_project/features/location_data/data/place.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:euk2_project/themes/theme_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: yellowTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: MapSample(),
    );
  }
}

// Clustering maps

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late ClusterManager _manager;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  final CameraPosition _randomPositionCZ =
  CameraPosition(target: LatLng(49.985929, 14.364725), zoom: 12.0);

  List<Place> items = [
    for (int i = 0; i < 10; i++)
      Place(
          address: 'Magistrát hl. m. Prahy, Staroměstská radnice s orlojem, Staroměstské náměstí 1/3',
          region: 'Hlavní město Praha',
          city: 'Praha 1',
          info: 'přízemí',
          ZIP: '110 00',
          type: EUKLocationType.wc,
          name: 'WC $i',
          latLng: LatLng(50.082340 + i * 0.001, 14.413304 + i * 0.001)),
    for (int i = 0; i < 10; i++)
      Place(
          name: 'HOSPITAL $i',
          address: 'Magistrát hl. m. Prahy, Staroměstská radnice s orlojem, Staroměstské náměstí 1/3',
          region: 'Hlavní město Praha',
          city: 'Praha 1',
          info: 'přízemí',
          ZIP: '110 00',
          type: EUKLocationType.wc,
          latLng: LatLng(50.087456 - i * 0.001, 14.432694 + i * 0.001)),
    for (int i = 0; i < 10; i++)
      Place(
          address: 'Magistrát hl. m. Prahy, Staroměstská radnice s orlojem, Staroměstské náměstí 1/3',
          region: 'Hlavní město Praha',
          city: 'Praha 1',
          info: 'přízemí',
          ZIP: '110 00',
          type: EUKLocationType.wc,
          name: 'Office $i',
          latLng: LatLng(50.015879 + i * 0.01, 14.430030 - i * 0.01)),
    for (int i = 0; i < 10; i++)
      Place(
          address: 'Magistrát hl. m. Prahy, Staroměstská radnice s orlojem, Staroměstské náměstí 1/3',
          region: 'Hlavní město Praha',
          city: 'Praha 1',
          info: 'přízemí',
          ZIP: '110 00',
          type: EUKLocationType.wc,
          name: 'Office $i',
          latLng: LatLng(50.041608 - i * 0.1, 14.315362 - i * 0.01)),
  ];

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }
  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: yellowTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: GoogleMap(
          initialCameraPosition: _randomPositionCZ,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
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
    final Paint paint1 = Paint()..color = Colors.orangeAccent;
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

