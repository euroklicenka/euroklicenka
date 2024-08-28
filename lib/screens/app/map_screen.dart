// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'dart:async';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  late final tileProvider = const FMTCStore('mapStore').getTileProvider();

  MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  DateTime onSearchlastSearch = DateTime.now();
  DateTime asyncSuggestionsLastSearch = DateTime.now();
  final _mapController = MapController();

  @override
  void dispose() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.followCurrentLocationStreamController.close();
    super.dispose();
  }

  EasySearchBar appBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final Color? foregroundColor = appBarTheme.foregroundColor;
    final IconThemeData iconTheme = appBarTheme.iconTheme ??
        theme.iconTheme.copyWith(color: foregroundColor);
    final appLocalizations = AppLocalizations.of(context)!;

    return EasySearchBar(
      title: Center(
        child: Text(appLocalizations.mapAppBarTitle),
      ),
      animationDuration: const Duration(milliseconds: 260),
      onSearch: (value) => onSearch(value),
      searchHintText: 'Ostrava...',
      debounceDuration: const Duration(milliseconds: 1000),
      asyncSuggestions: asyncSuggestions,
      onSuggestionTap: _onSuggestionTap,
      putActionsOnRight: true,
      actions: <Widget>[
        // FIXME: Deduplicate
        IconTheme(
          data: iconTheme,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                final locationProvider =
                    Provider.of<LocationProvider>(context, listen: false);
                // Follow the location marker on the map when location updated until user interact with the map.
                locationProvider.followOnLocationUpdate = AlignOnUpdate.once;

                // Follow the location marker on the map and zoom the map to level 18.
                locationProvider.followCurrentLocationStreamController
                    .add(locationProvider.currentMapZoom);

                await locationProvider.getCurrentPosition().catchError((e) {
                  showSnackBar(message: e.toString());
                });

                LatLng? position = locationProvider.currentUserPosition;
                if (position != null) {
                  _mapController.move(
                      position, locationProvider.currentMapZoom);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Map<String, Place> lastSuggestions = {};

  dynamic _onSuggestionTap(dynamic value) {
    if (lastSuggestions.containsKey(value)) {
      final place = lastSuggestions[value]!;
      _mapController.move(LatLng(place.lat, place.lon), 15);
    }

    hideVirtualKeyboard();

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
        Duration(milliseconds: 1000 - difference.inMilliseconds),
      );
    }

    final searchResult = await Nominatim.searchByName(
      query: value,
      limit: 20,
      addressDetails: true,
      // extraTags: true,
      nameDetails: true,
      // countryCodes: ['cz'],
    );

    final List<String> places = [];

    searchResult.sort(
      (a, b) => Geolocator.distanceBetween(
        _mapController.camera.center.latitude,
        _mapController.camera.center.longitude,
        a.lat,
        a.lon,
      ).compareTo(
        Geolocator.distanceBetween(
          _mapController.camera.center.latitude,
          _mapController.camera.center.longitude,
          b.lat,
          b.lon,
        ),
      ),
    );

    for (final place in searchResult) {
      final town = place.address?['city'] ??
          place.address?['town'] ??
          place.address?['village'] ??
          place.address?['municipality'];
      final suburb = place.address?['city_district'] ??
          place.address?['district'] ??
          place.address?['borough'] ??
          place.address?['suburb'] ??
          place.address?['subdivision'];

      final road = place.address?['road'];
      final roadStr = road ?? suburb ?? "";

      final houseNumber =
          place.address?['house_number'] ?? place.address?['house_name'];
      final houseNumberStr = (houseNumber != null) ? " $houseNumber" : "";

      final postCode = place.address?['postcode'];
      final postCodeStr = (postCode != null) ? "$postCode " : "";

      final roadTownSep = (roadStr != "" || houseNumberStr != "") ? ", " : "";

      final addressStr = "$roadStr$houseNumberStr$roadTownSep$postCodeStr$town";

      lastSuggestions[addressStr] = place;

      places.add(addressStr);
    }

    asyncSuggestionsLastSearch = DateTime.now();
    return places;
  }

  Future<void> onSearch(String value) async {}

  Future<bool> initialize(BuildContext context) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    await locationProvider.getCurrentPosition().catchError((e) {
      showSnackBar(message: e.toString());
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(context),
      builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar(context),
          body: mapScreenBody(),
        );
      },
    );
  }

  void _onPositionChanged(MapCamera mapCamera, bool hasGesture) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    if (hasGesture) {
      final eurolockProvider =
          Provider.of<EurolockProvider>(context, listen: false);
      eurolockProvider.currentEUK = null;

      if (locationProvider.followOnLocationUpdate != AlignOnUpdate.never) {
        locationProvider.followOnLocationUpdate = AlignOnUpdate.never;
      }
    }

    //if (locationProvider.followOnLocationUpdate != AlignOnUpdate.never) {
    //   locationProvider.currentUserPosition = mapPosition.center!;
    //}

    locationProvider.currentMapPosition = mapCamera.center;
    locationProvider.currentMapZoom = mapCamera.zoom;
  }

  Widget mapScreenBody() {
    return Consumer3<LocationProvider, PreferencesProvider, EurolockProvider>(
      builder: (
        context,
        locationProvider,
        preferencesProvider,
        eurolockProvider,
        child,
      ) {
        return Stack(
          children: <Widget>[
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onMapReady: () async {
                  eurolockProvider.mapController = _mapController;

                  await locationProvider.getCurrentPosition().catchError((e) {
                    showSnackBar(message: e.toString());
                  });

                  LatLng? position = locationProvider.currentUserPosition;
                  if (position != null) {
                    _mapController.move(
                        position, locationProvider.currentMapZoom);
                  }
                },
                initialCenter: locationProvider.currentMapPosition,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onTap: (tapPosition, point) =>
                    eurolockProvider.currentEUK = null,
                onPositionChanged: _onPositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'cz.osu.euroklicenka',
                  tileProvider: widget.tileProvider,
                  maxZoom: 19,
                ),
                MarkerLayer(markers: eurolockProvider.markers),
                CurrentLocationLayer(),
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
            Builder(
              builder: (context) {
                if (eurolockProvider.currentEUK == null) {
                  return const SizedBox.shrink();
                }
                final euk = eurolockProvider.currentEUK!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      surfaceTintColor: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          eurolockProvider.mapItemBuilder(context, euk),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 8,
                                ),
                                child: eurolockProvider.navigateButton(
                                    context, euk),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
