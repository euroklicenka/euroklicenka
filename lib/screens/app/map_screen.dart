import 'package:custom_info_window/custom_info_window.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/blocs/theme_switching_bloc/theme_switching_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';

///Screen that shows the primary map with EUK locations.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String googleApikey = "AIzaSyBpeiwg_btFCFZUbgOMelyFyee58gCiH-Q";
  GoogleMapController? mapController; //controller for Google map
  MapLoadingState _mapState = MapLoadingState.initializing;
  String location = "Search Location";

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LocationManagementBloc>();
    final ThemeSwitchingBloc themeBloc = context.watch<ThemeSwitchingBloc>();
    final double popupWindowFlexibleHeight =
        MediaQuery.of(context).size.height * 0.27;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          StreamBuilder<Set<Marker>>(
            initialData: const <Marker>{},
            stream: bloc.locationManager.markerStream,
            builder:
                (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
              return GoogleMap(
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  themeBloc.mapController = controller;
                  mapController = controller;
                  controller.setMapStyle(themeBloc.currentMapTheme);
                  bloc.locationManager.windowController.googleMapController =
                      controller;
                  bloc.add(OnMapIsReady(controller));
                  Future.delayed(const Duration(milliseconds: 610), () {
                    if (!mounted) return;
                    setState(() => _mapState = MapLoadingState.loading);
                  });
                },
                onTap: (position) =>
                    bloc.locationManager.windowController.hideInfoWindow!(),
                onCameraMove: (position) {
                  bloc.locationManager.windowController.onCameraMove!();
                  bloc.locationManager.clusterManager.onCameraMove(position);
                },
                markers: (snapshot.data == null)
                    ? <Marker>{}
                    : snapshot.data!.toSet(),
                initialCameraPosition: CameraPosition(
                  target:
                      context.watch<LocationManagementBloc>().wantedPosition ??
                          const LatLng(50.073658, 14.418540),
                  zoom:
                      context.watch<LocationManagementBloc>().wantedZoom ?? 6.0,
                ),
                onCameraIdle: () {
                  bloc.locationManager.clusterManager.updateMap();
                  bloc.locationManager.windowController.onCameraMove!();
                },
              );
            },
          ),
          Positioned(  //search input bar
               top:0,
               child: InkWell(
                 onTap: () async {
                  var place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: googleApikey,
                          mode: Mode.overlay,
                          types: [],
                          strictbounds: false,
                          language: 'cs',
                          components: [Component(Component.country, 'cz')],
                          resultTextStyle: Theme.of(context).textTheme.titleMedium,
                          onError: (err){
                             print(err);
                          }
                      );

                   if(place != null){
                        setState(() {
                          location = place.description.toString();
                        });

                       //form google_maps_webservice package
                       final plist = GoogleMapsPlaces(apiKey:googleApikey,
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                                        //from google_api_headers package
                        );
                        String placeid = place.placeId ?? "0";
                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;
                        var newlatlang = LatLng(lat, lang);
                        

                        //move map camera to selected place with animation
                        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                   }
                 },
                 child:Padding(
                   padding: EdgeInsets.all(5),
                    child: Card(
                       child: Container(
                         padding: EdgeInsets.all(0),
                         width: MediaQuery.of(context).size.width - 70,
                         child: ListTile(
                            title:Text(location, style: TextStyle(fontSize: 12),),
                            trailing: Icon(Icons.search),
                            dense: true,
                         )
                       ),
                    ),
                 )
               )
             ),
          buildMapLoader(
            context: context,
            ignoreInputWhen: _mapState != MapLoadingState.finished,
          ),
          CustomInfoWindow(
            controller: context
                .watch<LocationManagementBloc>()
                .locationManager
                .windowController,
            height: (popupWindowFlexibleHeight < 180)
                ? 180
                : popupWindowFlexibleHeight,
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
  Widget buildMapLoader({
    required BuildContext context,
    bool ignoreInputWhen = true,
  }) {
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
                SizedBox(
                  height: 16,
                ),
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
      title: const Text('Místa osazená Euroklíčem'),
      centerTitle: true,
    );
  }
}

enum MapLoadingState { initializing, loading, finished }
