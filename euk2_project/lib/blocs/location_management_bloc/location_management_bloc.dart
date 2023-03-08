import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/location_manager.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:euk2_project/features/location_data/user_pos_locator.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'location_management_event.dart';

part 'location_management_state.dart';

///Stores location data.
class LocationManagementBloc
    extends Bloc<LocationManagementEvent, LocationManagementState> {
  final UserPositionLocator _userLocation = UserPositionLocator();

  late ScreenNavigationBloc _navigationBloc;
  late EUKLocationManager locationManager;

  LatLng? wantedPosition;
  double? wantedZoom;

  LocationManagementBloc({required ScreenNavigationBloc navigationBloc})
      : super(const LocationManagementDefault()) {
    _navigationBloc = navigationBloc;
    on<OnFocusOnLocation>(_onFocusOnLocation);
    on<OnFocusOnEUKLocation>(_onFocusOnEUKLocation);
    on<OnFocusOnUserPosition>(_onFocusOnUserPosition);
    on<OnCanFocus>(_onCanFocus);
    on<OnLoadLocationsFromDatabase>(_onLoadFromDatabase);
  }

  ///Async constructor for [LocationManagementBloc].
  Future<void> create({required UserDataManager dataManager}) async {
    locationManager = EUKLocationManager(dataManager: dataManager);
    locationManager.reloadFromLocalStorage();
    await _userLocation.initLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) => _userLocation.updateLocation());
    await _userLocation.updateLocation();
  }

  Future<void> _onFocusOnLocation(OnFocusOnLocation event, emit) async {
    emit(const LocationManagementFocusing());

    //Switch to the map screen
    _navigationBloc.add(OnSwitchPage.screen(ScreenType.map));
    wantedPosition = LatLng(event.location.latitude + 0.003, event.location.longitude);
    wantedZoom = event.zoom;

  }

  Future<FutureOr<void>> _onFocusOnEUKLocation(OnFocusOnEUKLocation event, emit) async {
    final EUKLocationData data = locationManager.locations.where((d) => d.id == event.locationID).first;

    await _onFocusOnLocation(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom), emit);
    locationManager.windowController.addInfoWindow!(buildPopUpWindow(data), LatLng(data.lat, data.long));
  }

  Future<void> _onFocusOnUserPosition(OnFocusOnUserPosition event, emit) async {
    await _onFocusOnLocation(
        OnFocusOnLocation(_userLocation.currentPosition,
            zoom: _userLocation.zoomAmount),
        emit);
  }

  Future<void> _onCanFocus(OnCanFocus event, emit) async {
    if (wantedPosition == null) return;

    try {
      await locationManager.windowController.googleMapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(wantedPosition ?? _userLocation.currentPosition, wantedZoom ?? 15));
      wantedPosition = null;
      wantedZoom = null;
    } on MissingPluginException {
      //TODO throw error: 'The camera could not zoom on a position, map cannot be accessed.'
    }

    emit(const LocationManagementDefault());
  }

  Future<void> _onLoadFromDatabase(
      OnLoadLocationsFromDatabase event, emit) async {
    locationManager.reloadFromDatabase();
  }

  ScreenNavigationBloc get navigationBloc => _navigationBloc;


}
