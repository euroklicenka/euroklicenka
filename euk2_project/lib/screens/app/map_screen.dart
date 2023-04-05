import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
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
    final bloc = context.read<LocationManagementBloc>();
    return Stack(
      children: <Widget>[
        StreamBuilder<Set<Marker>>(
          initialData: const <Marker>{},
          stream: bloc.locationManager.markerStream,
          builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
            return GoogleMap(
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                bloc.locationManager.windowController.googleMapController = controller;
                bloc.add(OnMapIsReady(controller));
              },
              onTap: (position) => bloc.locationManager.windowController.hideInfoWindow!(),
              onCameraMove: (position) {
                bloc.locationManager.windowController.onCameraMove!();
                bloc.locationManager.clusterManager.onCameraMove(position);
              },
              markers: (snapshot.data == null) ? <Marker>{} : snapshot.data!.toSet(),
              initialCameraPosition: CameraPosition(target: context.watch<LocationManagementBloc>().wantedPosition ?? const LatLng(50.073658, 14.418540), zoom: context.watch<LocationManagementBloc>().wantedZoom ?? 6.0,),
              onCameraIdle: () {
                bloc.locationManager.clusterManager.updateMap();
                bloc.locationManager.windowController.onCameraMove!();
              },
            );
          },
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
