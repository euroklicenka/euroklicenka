import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/external_map/map_app_dialog.dart';
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

part 'external_map_event.dart';

part 'external_map_state.dart';

///Handles events dealing with external map applications.
class ExternalMapBloc extends Bloc<ExternalMapEvent, ExternalMapState> {

  late List<AvailableMap> _availableMaps;

  ExternalMapBloc() : super(ExternalMapInitial()) {
    on<OnOpenForNavigation>(_onNavigate);
  }

  Future<void> _onNavigate(OnOpenForNavigation event, emit) async {
    await _refreshAvailableMaps();

    if (_availableMaps.isEmpty) {
      showSnackBar(message: 'Navigování nemůže být spuštěno.\nNa zařízení není nainstalovaná žádná podporovaná aplikace.');
      return;
    }

    openMapAppDialog(
      context: event.context,
      maps: _availableMaps,
      onSelect: (map) {
        Navigator.pop(event.context);
        return map.showDirections(destination: Coords(event.lat, event.long));
      },
    );
  }

  Future<void> _refreshAvailableMaps() async => _availableMaps = await MapLauncher.installedMaps;
}
