import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Location _currentLocation = Location();
  LatLng initPosition = const LatLng(50.073658, 14.418540);
  final double _zoom = 15;
  List<String> images = ['assets/images/car.png', 'images/marker.png ,'];


  //zobrazení aktuální pozice uživatele
  Future<void> getLocation() async {
    _currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
            zoom: 10.0,
          ),
        ),
      );
    });
  }

  final MapType _currentMapType = MapType.normal;

  @override
  void dispose() {
    context.read<MainScreenBloc>().locationManager.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // loadData() ;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa míst'),
        centerTitle: true,
      ),
      // drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              context.read<MainScreenBloc>().locationManager.windowController.googleMapController = controller;
            },
            onTap: (position) {
              context.read<MainScreenBloc>().locationManager.windowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              context.read<MainScreenBloc>().locationManager.windowController.onCameraMove!();
            },
            mapType: _currentMapType,
            markers: context.read<MainScreenBloc>().locationManager.markers,
            initialCameraPosition: const CameraPosition(
              //target: LatLng(0.0, 0.0),
              target: LatLng(50.073658, 14.418540),
              zoom: 6.0,
            ),
          ),
          CustomInfoWindow(
            controller: context.read<MainScreenBloc>().locationManager.windowController,
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 70,
          ),
        ],
      ),
    );
  }
}
