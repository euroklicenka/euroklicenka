import 'dart:async';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final MapController mapController = MapController();

  MapScreen({super.key});

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
      body: MapScreenBody(mapController: mapController),
    );
  }
}

///Screen that shows the primary map with EUK locations.
class MapScreenBody extends StatefulWidget {
  final MapController? mapController;

  const MapScreenBody({
    super.key,
    required this.mapController,
  });

  @override
  State<MapScreenBody> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenBody> {
  late AlignOnUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = AlignOnUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  void _onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    if (hasGesture) {
      final eurolockModel = Provider.of<EurolockModel>(context, listen: false);
      eurolockModel.currentEUK = null;
    }

    if (hasGesture && _followOnLocationUpdate != AlignOnUpdate.never) {
      setState(
        () => _followOnLocationUpdate = AlignOnUpdate.never,
      );
    }

    final locationProvider = Provider.of<LocationModel>(context, listen: false);
    locationProvider.currentMapPosition = mapPosition.center!;
    locationProvider.currentMapZoom = mapPosition.zoom!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LocationModel, PreferencesModel, EurolockModel>(
      builder: (context, locProvider, prefProvider, eukModel, child) {
        eukModel.mapController = widget.mapController;
        return Stack(
          children: <Widget>[
            FlutterMap(
              mapController: widget.mapController,
              options: MapOptions(
                initialCenter: locProvider.currentMapPosition,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                onTap: (tapPosition, point) => eukModel.currentEUK = null,
                onPositionChanged: _onPositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'cz.osu.euroklicenka',
                ),
                CurrentLocationLayer(
                  alignPositionStream:
                      _followCurrentLocationStreamController.stream,
                  alignPositionOnUpdate: _followOnLocationUpdate,
                ),
                MarkerLayer(markers: eukModel.markers),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 20,
              top: 20,
              child: FloatingActionButton(
                onPressed: () {
                  // Follow the location marker on the map when location updated until user interact with the map.
                  setState(
                    () => _followOnLocationUpdate = AlignOnUpdate.always,
                  );
                  // Follow the location marker on the map and zoom the map to level 18.
                  _followCurrentLocationStreamController.add(18);
                },
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (eukModel.currentEUK == null) {
                  return const SizedBox.shrink();
                }
                final euk = eukModel.currentEUK!;

                _followOnLocationUpdate = AlignOnUpdate.never;

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
      },
    );
  }
}
