import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_zoom_info.dart';
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
class LocationManagementBloc extends Bloc<LocationManagementEvent, LocationManagementState> {
  final UserPositionLocator _userLocation = UserPositionLocator();
  final LocationZoomInfo zoomInfo = LocationZoomInfo();

  late ScreenNavigationBloc _navigationBloc;
  late EUKLocationManager locationManager;


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
    zoomInfo.wantedPosition = event.location;
    zoomInfo.wantedZoom = event.zoom;
  }

  Future<FutureOr<void>> _onFocusOnEUKLocation(OnFocusOnEUKLocation event, emit) async {
    final EUKLocationData data = locationManager.locations.where((d) => d.id == event.locationID).first;
    zoomInfo.popupWindow = buildPopUpWindow(data);

    await _onFocusOnLocation(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom), emit);
  }

  Future<void> _onFocusOnUserPosition(OnFocusOnUserPosition event, emit) async {
    await _onFocusOnLocation(
        OnFocusOnLocation(_userLocation.currentPosition,
            zoom: _userLocation.zoomAmount),
        emit);
  }

  Future<void> _onCanFocus(OnCanFocus event, emit) async {
    if (zoomInfo.wantedPosition == null) return;

    try {
      final LatLng offsetPosition = LatLng(zoomInfo.wantedPosition!.latitude + 0.003, zoomInfo.wantedPosition!.longitude);
      await locationManager.windowController.googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(offsetPosition, zoomInfo.wantedZoom!));
      if (zoomInfo.popupWindow != null) locationManager.windowController.addInfoWindow!(zoomInfo.popupWindow!, zoomInfo.wantedPosition!);
      zoomInfo.clear();
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
