import 'package:custom_info_window/custom_info_window.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/blocs/theme_switching_bloc/theme_switching_bloc.dart';
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
  MapLoadingState _mapState = MapLoadingState.initializing;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LocationManagementBloc>();
    final String mapStyle = context.watch<ThemeSwitchingBloc>().currentMapTheme;
    final double popupWindowFlexibleHeight = MediaQuery.of(context).size.height * 0.27;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          StreamBuilder<Set<Marker>>(
            initialData: const <Marker>{},
            stream: bloc.locationManager.markerStream,
            builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
              return GoogleMap(
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(mapStyle);
                  bloc.locationManager.windowController.googleMapController = controller;
                  bloc.add(OnMapIsReady(controller));
                  Future.delayed(const Duration(milliseconds: 610), () {
                    if (!mounted) return;
                    setState(() => _mapState = MapLoadingState.loading);
                  });
                },
                onTap: (position) => bloc.locationManager.windowController.hideInfoWindow!(),
                onCameraMove: (position) {
                  bloc.locationManager.windowController.onCameraMove!();
                  bloc.locationManager.clusterManager.onCameraMove(position);
                },
                markers: (snapshot.data == null) ? <Marker>{} : snapshot.data!.toSet(),
                initialCameraPosition: CameraPosition(
                  target: context.watch<LocationManagementBloc>().wantedPosition ?? const LatLng(50.073658, 14.418540),
                  zoom: context.watch<LocationManagementBloc>().wantedZoom ?? 6.0,
                ),
                onCameraIdle: () {
                  bloc.locationManager.clusterManager.updateMap();
                  bloc.locationManager.windowController.onCameraMove!();
                },
              );
            },
          ),
          buildMapLoader(
            context: context,
            ignoreInputWhen: _mapState != MapLoadingState.finished,
          ),
          CustomInfoWindow(
            controller: context.watch<LocationManagementBloc>().locationManager.windowController,
            height: (popupWindowFlexibleHeight < 180) ? 180 : popupWindowFlexibleHeight,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 70,
          ),
        ],
      ),
    );
  }

  ///Builds a loading screen to mask map initialization.
  ///
  ///The loading screen blocks input when [ignoreInputWhen] is TRUE.
  Widget buildMapLoader({required BuildContext context, bool ignoreInputWhen = true}) {
    return IgnorePointer(
      ignoring: ignoreInputWhen,
      child: AnimatedOpacity(
        curve: Curves.fastOutSlowIn,
        opacity: _mapState != MapLoadingState.initializing ? 0 : 1,
        duration: const Duration(milliseconds: 300),
        onEnd: () => setState(() => _mapState == MapLoadingState.finished),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text('Vykreslování mapy'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///The AppBar for the Map Screen.
class AppBarMapScreen extends StatelessWidget {
  const AppBarMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Mapa'),
      centerTitle: true,
    );
  }
}

enum MapLoadingState { initializing, loading, finished }
