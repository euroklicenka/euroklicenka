import 'dart:async';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final MapController mapController = MapController();

  MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  DateTime onSearchlastSearch = DateTime.now();
  DateTime asyncSuggestionsLastSearch = DateTime.now();

  EasySearchBar appBar(BuildContext context) {
    // final locationModel = Provider.of<LocationModel>(context);
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
      onSearch: (value) => onSearch(value),
      searchHintText: 'Ostrava...',
      debounceDuration: const Duration(milliseconds: 1000),
      asyncSuggestions: asyncSuggestions,
      // suggestions: lastSuggestions,
      suggestionBackgroundColor: Theme.of(context).colorScheme.surface,
      onSuggestionTap: _onSuggestionTap,
    );
  }

  Map<String, Place> lastSuggestions = {};

  String? _onSuggestionTap(String? value) {
    if (lastSuggestions.containsKey(value)) {
      final place = lastSuggestions[value]!;
      widget.mapController.move(LatLng(place.lat, place.lon), 15);
    }

    return value;
  }

  Future<List<String>> asyncSuggestions(String? value) async {
    if (value == null || value.length < 3) {
      return [];
    }

    final dt = DateTime.now();
    final difference = dt.difference(asyncSuggestionsLastSearch);
    if (difference.inMilliseconds < 1000) {
      // this should not happen, but just in case...
      await Future.delayed(
          Duration(milliseconds: 1000 - difference.inMilliseconds));
    }

    final searchResult = await Nominatim.searchByName(
      query: value,
      limit: 20,
      addressDetails: true,
      // extraTags: true,
      nameDetails: true,
      // countryCodes: ['cz'],
    );

    List<String> places = [];

    searchResult.sort((a, b) => Geolocator.distanceBetween(
            widget.mapController.camera.center.latitude,
            widget.mapController.camera.center.longitude,
            a.lat,
            a.lon)
        .compareTo(Geolocator.distanceBetween(
            widget.mapController.camera.center.latitude,
            widget.mapController.camera.center.longitude,
            b.lat,
            b.lon)));

    for (final place in searchResult) {
      String? town = place.address?['city'] ??
          place.address?['town'] ??
          place.address?['village'] ??
          place.address?['municipality'];
      String? suburb = place.address?['city_district'] ??
          place.address?['district'] ??
          place.address?['borough'] ??
          place.address?['suburb'] ??
          place.address?['subdivision'];

      final String? road = place.address?['road'];
      final String roadStr =
          (road != null) ? road : suburb ?? "where the streets have no name";

      final houseNumber =
          place.address?['house_number'] ?? place.address?['house_name'];
      final String houseNumberStr =
          (houseNumber != null) ? " $houseNumber" : "";

      final postCode = place.address?['postcode'];
      final postCodeStr = (postCode != null) ? "$postCode " : "";

      final addressStr = "$roadStr$houseNumberStr, $postCodeStr$town";

      print(place.nameDetails);

      lastSuggestions[addressStr] = place;

      // FIXME: sort by distance???
      places.add(addressStr);
    }

    asyncSuggestionsLastSearch = DateTime.now();
    return places;
  }

  Future<void> onSearch(String value) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      body: MapScreenBody(mapController: widget.mapController),
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
    _followOnLocationUpdate = AlignOnUpdate.once;
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
    if (_followOnLocationUpdate != AlignOnUpdate.never) {
      locationProvider.currentUserPosition = mapPosition.center!;
    }

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
                    () => _followOnLocationUpdate = AlignOnUpdate.once,
                  );
                  // Follow the location marker on the map and zoom the map to level 18.
                  _followCurrentLocationStreamController
                      .add(locProvider.currentMapZoom);
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
