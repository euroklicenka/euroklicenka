// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  PreferredSizeWidget appBar(BuildContext context) {
    final eurolockProvider =
        Provider.of<EurolockProvider>(context, listen: false);
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
      onSearch: (value) => eurolockProvider.onSearch(value),
      searchHintText: 'Ostrava...',
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

                await locationProvider.getCurrentPosition().catchError((e) {
                  showSnackBar(message: e.toString());
                  return null;
                });

                // Follow the location marker on the map when location updated until user interact with the map.
                locationProvider.followOnLocationUpdate = AlignOnUpdate.once;

                // Follow the location marker on the map and zoom the map to level 18.
                locationProvider.followCurrentLocationStreamController
                    .add(locationProvider.currentMapZoom);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      body: const ListScreenBody(),
    );
  }
}

class ListScreenBody extends StatefulWidget {
  const ListScreenBody({super.key});

  @override
  State<ListScreenBody> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreenBody> {
  Future<List<Widget>> _loadData(
    BuildContext context,
    EurolockProvider eukProvider,
    LocationProvider locationProvider,
  ) async {
    final list = await eukProvider.getList(
      context,
      locationProvider.currentUserPosition,
      locationProvider.currentMapPosition,
    );
    return list;
  }

  String loadingDataMessage() => Intl.message(
        AppLocalizations.of(context)!.uploadingdataMessage,
        name: 'ListScreen_loadingDataMessage',
        args: [],
        desc: 'Simple indicator that we are loading data',
      );

  @override
  Widget build(BuildContext context) {
    return Consumer2<EurolockProvider, LocationProvider>(
      builder: (context, eukProvider, locationProvider, child) {
        return FutureBuilder<List<Widget>>(
          future: _loadData(context, eukProvider, locationProvider),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              assert(snapshot.data != null);
              return ListView(children: snapshot.data!); // snapshot.data!
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error.toString());
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(loadingDataMessage()),
              );
            }
          },
        );
      },
    );
  }
}
