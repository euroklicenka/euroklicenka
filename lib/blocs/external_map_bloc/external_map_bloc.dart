// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:eurokey2/features/data_management/user_data_manager.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/widgets/dialogs/map_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

part 'external_map_event.dart';
part 'external_map_state.dart';

///Handles events dealing with external map applications.
class ExternalMapBloc extends Bloc<ExternalMapEvent, ExternalMapState> {
  late UserDataManager _dataManager;

  List<AvailableMap> _availableMaps = [];
  bool _nextAppIsDefault = false;
  String _defaultMapIcon = '';

  ExternalMapBloc({required UserDataManager dataManager})
      : super(ExternalMapDefaultState()) {
    _dataManager = dataManager;
    on<OnOpenForNavigation>(_onNavigate);
    on<OnChangeDefaultMapApp>(_onChangeDefaultMapApp);
    on<OnFinishDefaultMapAppSetting>(_onFinishDefaultMapAppSetting);
    on<OnRedrawDefaultIcon>(_onInit);
  }

  void updateNextAppIsDefault(bool value) {
    _nextAppIsDefault = value;
    emit(ExternalMapDefaultState());
  }

  Future<void> _onNavigate(OnOpenForNavigation event, emit) async {
    await _refreshAvailableMaps();

    if (_availableMaps.isEmpty) {
      showSnackBar(
          message:
              'Navigování nemůže být spuštěno.\nNa zařízení není nainstalovaná žádná podporovaná aplikace.',);
      return;
    }

    if (_availableMaps.length == 1) {
      _showDirections(_availableMaps[0], event);
      return;
    }

    final int savedMapIndex = _dataManager.loadDefaultMapAppIndex();
    if (savedMapIndex != -1) {
      final MapType type = MapType.values[savedMapIndex];
      final AvailableMap? map =
          _availableMaps.firstWhereOrNull((m) => m.mapType == type);
      if (map != null) {
        _showDirections(map, event);
        return;
      }
    }

    if (!event.context.mounted) return;
    openMapAppDialog(
      context: event.context,
      maps: _availableMaps,
      onSelect: (map) {
        if (_nextAppIsDefault == true) {
          _saveMapAppIndex(map.mapType.index);
          _defaultMapIcon = map.icon;
        }
        Navigator.pop(event.context);
        _showDirections(map, event);
      },
    );
  }

  Future<void> _onChangeDefaultMapApp(OnChangeDefaultMapApp event, emit) async {
    await _refreshAvailableMaps();

    if (_availableMaps.length <= 1) {
      showSnackBar(
          message:
              'Není možné změnit.\nAplikace detekovala pouze 1 podporovanou navigaci.',);
      _defaultMapIcon = _availableMaps[0].icon;
      emit(ExternalMapDefaultState());
      return;
    }

    if (!event.context.mounted) return;

    openMapAppDialog(
      context: event.context,
      maps: _availableMaps,
      headerText: 'Změnit výchozí navigaci',
      showDefaultSwitch: false,
      onSelect: (map) {
        add(OnFinishDefaultMapAppSetting(
            context: event.context,
            mapIndex: map.mapType.index,
            mapIcon: map.icon,),);
        Navigator.pop(event.context);
      },
      onSelectNone: () {
        add(OnFinishDefaultMapAppSetting(
            context: event.context, mapIndex: -1, mapIcon: '',),);
        Navigator.pop(event.context);
      },
    );
  }

  void _onFinishDefaultMapAppSetting(OnFinishDefaultMapAppSetting event, emit) {
    _saveMapAppIndex(event.mapIndex);
    _defaultMapIcon = event.mapIcon;
    emit(ExternalMapDefaultState());
  }

  ///Tries to return the icon of the currently saved map app.
  String _tryLoadIcon() {
    final int mapIndex = _dataManager.loadDefaultMapAppIndex();

    if (_availableMaps.length == 1) return _availableMaps[0].icon;
    if (mapIndex < 0 || mapIndex > MapType.values.length) return '';

    final MapType wantedType = MapType.values[mapIndex];
    final AvailableMap? map =
        _availableMaps.firstWhereOrNull((m) => m.mapType == wantedType);
    return (map != null) ? map.icon : '';
  }

  Future<void> _onInit(OnRedrawDefaultIcon event, emit) async {
    await _refreshAvailableMaps();
    _defaultMapIcon = _tryLoadIcon();
    emit(ExternalMapDefaultState());
  }

  Future<void> _refreshAvailableMaps() async =>
      _availableMaps = await MapLauncher.installedMaps;
  void _showDirections(AvailableMap map, OnOpenForNavigation event) =>
      map.showDirections(destination: Coords(event.lat, event.long));
  void _saveMapAppIndex(int index) => _dataManager.saveDefaultMapApp(index);

  bool get nextAppIsDefault => _nextAppIsDefault;
  String get defaultMapIcon => _defaultMapIcon;
}
