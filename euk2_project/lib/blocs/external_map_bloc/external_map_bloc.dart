import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/external_map/map_app_dialog.dart';
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:collection/collection.dart';

part 'external_map_event.dart';

part 'external_map_state.dart';

///Handles events dealing with external map applications.
class ExternalMapBloc extends Bloc<ExternalMapEvent, ExternalMapState> {

  late UserDataManager _dataManager;

  List<AvailableMap> _availableMaps = [];
  bool _nextAppIsDefault = false;

  ExternalMapBloc({required UserDataManager dataManager}) : super(ExternalMapDefault()) {
    _dataManager = dataManager;
    on<OnOpenForNavigation>(_onNavigate);
    on<OnChangeDefaultMapApp>(_onChangeDefaultMapApp);
  }

  void updateNextAppIsDefault(bool value) {
    _nextAppIsDefault = value;
    emit(ExternalMapDefault());
  }

  Future<void> _onNavigate(OnOpenForNavigation event, emit) async {
    await _refreshAvailableMaps();

    if (_availableMaps.isEmpty) {
      showSnackBar(message: 'Navigování nemůže být spuštěno.\nNa zařízení není nainstalovaná žádná podporovaná aplikace.');
      return;
    }

    final int savedMapIndex = _dataManager.getDefaultMapAppIndex();
    if (savedMapIndex != -1) {
      final MapType type = MapType.values[savedMapIndex];
      final AvailableMap? map = _availableMaps.firstWhereOrNull((m) => m.mapType == type);
      if (map != null){
        _showDirections(map, event);
        return;
      }
    }

    openMapAppDialog(
      context: event.context,
      maps: _availableMaps,
      onSelect: (map) {
        if (_nextAppIsDefault == true) {
          _saveMapAppIndex(map.mapType.index);
        }
          Navigator.pop(event.context);
          _showDirections(map, event);
      },
    );
  }

  Future<void> _onChangeDefaultMapApp(OnChangeDefaultMapApp event, emit) async {
    await _refreshAvailableMaps();
    openMapAppDialog(
        context: event.context,
        maps: _availableMaps,
        showDefaultSwitch: false,
        onSelect: (map) {
          _saveMapAppIndex(map.mapType.index);
          Navigator.pop(event.context);
        },
        onSelectNone: () {
          _saveMapAppIndex(-1);
          Navigator.pop(event.context);
        }
    );
  }

  Future<void> _refreshAvailableMaps() async => _availableMaps = await MapLauncher.installedMaps;
  void _showDirections(AvailableMap map, OnOpenForNavigation event) => map.showDirections(destination: Coords(event.lat, event.long));
  void _saveMapAppIndex(int index) => _dataManager.saveDefaultMapApp(index);

  bool get nextAppIsDefault => _nextAppIsDefault;
}
