import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Screen that shows the primary map with EUK locations.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              context.read<LocationManagementBloc>().locationManager.windowController.googleMapController = controller;
            },
            onTap: (position) => context.read<LocationManagementBloc>().locationManager.windowController.hideInfoWindow!(),
            onCameraMove: (position) => context.read<LocationManagementBloc>().locationManager.windowController.onCameraMove!(),
            mapType: MapType.normal,
            markers: context.watch<LocationManagementBloc>().locationManager.markers,
            initialCameraPosition: const CameraPosition(
              //target: LatLng(0.0, 0.0),
              target: LatLng(50.073658, 14.418540),
              zoom: 6.0,
            ),
          ),
          CustomInfoWindow(
            controller: context.watch<LocationManagementBloc>().locationManager.windowController,
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 70,
          ),
        ],
      );
  }
}

///The AppBar for the Map Screen.
class AppBarMapScreen extends StatelessWidget {
  const AppBarMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Mapa míst'),
      centerTitle: true,
    );
  }
}

