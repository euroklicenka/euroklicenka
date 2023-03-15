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
  final LocationZoomInfo _zoomInfo = LocationZoomInfo();

  late ScreenNavigationBloc _navigationBloc;
  late EUKLocationManager locationManager;


  LocationManagementBloc({required ScreenNavigationBloc navigationBloc})
      : super(const LocationManagementDefault()) {
    _navigationBloc = navigationBloc;
    on<OnFocusOnLocation>(_onFocusOnLocation);
    on<OnFocusOnEUKLocation>(_onFocusOnEUKLocation);
    on<OnFocusOnUserPosition>(_onFocusOnUserPosition);
    on<OnMapIsReady>(_onMapIsReady);
    on<OnLoadLocationsFromDatabase>(_onLoadFromDatabase);
  }

  ///Async constructor for [LocationManagementBloc].
  Future<void> create({required UserDataManager dataManager}) async {
    locationManager = EUKLocationManager(dataManager: dataManager);
    locationManager.reloadFromLocalStorage();
    await _userLocation.initLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) => _userLocation.updateLocation());
    await _userLocation.updateLocation();
    await _onFocusOnUserPosition(OnFocusOnUserPosition(), emit);
  }

  Future<void> _onFocusOnLocation(OnFocusOnLocation event, emit) async {
    _zoomInfo.wantedPosition = LatLng(event.location.latitude, event.location.longitude);
    _zoomInfo.wantedZoom = event.zoom;

    //Switch to the map screen
    _navigationBloc.add(OnSwitchPage.screen(ScreenType.map));
  }

  Future<FutureOr<void>> _onFocusOnEUKLocation(OnFocusOnEUKLocation event, emit) async {
    final EUKLocationData data = locationManager.locations.where((d) => d.id == event.locationID).first;
    _zoomInfo.popupWindow = buildPopUpWindow(data);
    await _onFocusOnLocation(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom), emit);
  }

  Future<void> _onFocusOnUserPosition(OnFocusOnUserPosition event, emit) async {
    await _onFocusOnLocation(OnFocusOnLocation(_userLocation.currentPosition, zoom: _userLocation.zoomAmount), emit);
  }

  Future<void> _onMapIsReady(OnMapIsReady event, emit) async {
    locationManager.clusterManager.setMapId(event.mapController.mapId);

    if (_zoomInfo.wantedPosition == null) return;
    if (_zoomInfo.popupWindow == null) return;

    locationManager.windowController.addInfoWindow!(_zoomInfo.popupWindow!, _zoomInfo.wantedPosition!);
    _zoomInfo.clear();
  }

  Future<void> _onLoadFromDatabase(
      OnLoadLocationsFromDatabase event, emit) async {
    locationManager.reloadFromDatabase();
  }

  ScreenNavigationBloc get navigationBloc => _navigationBloc;
  LatLng? get wantedPosition => _zoomInfo.wantedPosition;
  double? get wantedZoom => _zoomInfo.wantedZoom;
}
