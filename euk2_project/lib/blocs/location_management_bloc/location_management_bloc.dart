import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/location_manager.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:euk2_project/features/location_data/user_pos_locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'location_management_event.dart';

part 'location_management_state.dart';

///Stores location data.
class LocationManagementBloc extends Bloc<LocationManagementEvent, LocationManagementState> {

  final ScreenNavigationBloc navigationBloc;

  final UserPositionLocator _userLocation = UserPositionLocator();
  late EUKLocationManager locationManager;

  LocationManagementBloc({required this.navigationBloc}) : super(const LocationManagementDefault()) {
    on<OnFocusOnLocation>(_onFocusOnLocation);
    on<OnFocusOnEUKLocation>(_onFocusOnEUKLocation);
    on<OnFocusOnUserPosition>(_onFocusOnUserPosition);
    on<OnLoadLocationsFromDatabase>(_onLoadFromDatabase);
  }

  ///Async constructor for [LocationManagementBloc].
  Future<void> create() async {
    locationManager = EUKLocationManager();
    locationManager.reloadFromDatabase();
    await _userLocation.initLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) => _userLocation.updateLocation());
    await _userLocation.updateLocation();
  }

  Future<void> _onFocusOnLocation(OnFocusOnLocation event, emit) async {
    emit(const LocationManagementFocusing());

    //Switch to the map screen
    navigationBloc.add(OnSwitchPage.screen(ScreenType.map));
    await Future.delayed(const Duration(seconds: 5));

    await locationManager.windowController.googleMapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(event.location.latitude + 0.003, event.location.longitude), event.zoom,));



    emit(const LocationManagementDefault());
  }

  Future<FutureOr<void>> _onFocusOnEUKLocation(OnFocusOnEUKLocation event, emit) async {
    final EUKLocationData data = locationManager.locations.where((d) => d.id == event.locationID).first;

    await _onFocusOnLocation(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom), emit);
    locationManager.windowController.addInfoWindow!(buildPopUpWindow(data), LatLng(data.lat, data.long));
  }

  Future<void> _onFocusOnUserPosition(OnFocusOnUserPosition event, emit) async {
    await _onFocusOnLocation(OnFocusOnLocation(_userLocation.currentPosition, zoom: _userLocation.zoomAmount), emit);
  }

  Future<void> _onLoadFromDatabase(OnLoadLocationsFromDatabase event, emit) async {
    locationManager.reloadFromDatabase();
  }
}
