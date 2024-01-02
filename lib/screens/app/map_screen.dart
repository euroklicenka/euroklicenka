import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/themes/map_theme_manager.dart';
import 'package:eurokey2/themes/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  EasySearchBar appBar(BuildContext context) {
    final locationModel = Provider.of<LocationModel>(context);
    return EasySearchBar(
      title: const Center(
        child: Text('Mapa nejbližších míst'),
      ),
      animationDuration: const Duration(milliseconds: 260),
      searchClearIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: Theme.of(context).colorScheme.surface,
      onSearch: (value) => locationModel.onSearch(value),
      searchHintText: 'Ostrava...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      body: const MapScreenBody(),
    );
  }
}

///Screen that shows the primary map with EUK locations.
class MapScreenBody extends StatefulWidget {
  const MapScreenBody({
    super.key,
  });

  @override
  State<MapScreenBody> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenBody> {
  GoogleMapController? mapController;

  Future<void> _onCameraMove(CameraPosition position) async {
    final locProvider = Provider.of<LocationModel>(context, listen: false);

    locProvider.currentMapPosition = position.target;
    locProvider.currentMapZoom = position.zoom;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final prefProvider = Provider.of<PreferencesModel>(context, listen: false);
    final String mapTheme;

    switch (prefProvider.themeMode) {
      case ThemeMode.system:
        if (isSystemDarkModeActive()) {
          mapTheme = await MapThemeManager().darkTheme;
        } else {
          mapTheme = await MapThemeManager().lightTheme;
        }
      case ThemeMode.light:
        mapTheme = await MapThemeManager().lightTheme;
      case ThemeMode.dark:
        mapTheme = await MapThemeManager().darkTheme;
      default:
        throw const MapStyleException("invalid themeMode");
    }

    controller.setMapStyle(mapTheme);

    mapController = controller;
  }

  Future<Map<String, Marker>> _loadData() async {
    final eukModel = Provider.of<EurolockModel>(context, listen: false);
    return await eukModel.getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationModel, PreferencesModel>(
      builder: (context, locProvider, prefProvider, child) {
        return FutureBuilder<Map<String, Marker>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Map<String, Marker> markers = snapshot.data!;

              final eukModel =
                  Provider.of<EurolockModel>(context, listen: false);

              return Stack(
                children: <Widget>[
                  GoogleMap(
                    buildingsEnabled: false,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: locProvider.currentUserPosition ??
                          locProvider.currentMapPosition,
                      zoom: locProvider.currentMapZoom,
                    ),
                    onCameraMove: _onCameraMove,
                    onTap: (position) => eukModel.currentEUK = null,
                    markers: markers.values.toSet(),
                  ),
                  Consumer<EurolockModel>(
                    builder: (context, eukModel, child) {
                      if (eukModel.currentEUK == null) {
                        return const SizedBox.shrink();
                      }
                      final euk = eukModel.currentEUK!;

                      mapController?.moveCamera(
                        CameraUpdate.newLatLng(LatLng(euk.lat, euk.lng)),
                      );

                      return Positioned(
                        bottom: 0,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ColoredBox(
                          color: Theme.of(context).colorScheme.surface,
                          child: eukModel.mapItemBuilder(context, euk),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error.toString());
            } else {
              return const Text("loading data...");
            }
          },
        );
      },
    );
  }
}
