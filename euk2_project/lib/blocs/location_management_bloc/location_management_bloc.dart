import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_zoom_info.dart';
import 'package:eurokey2/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/features/location_data/location_manager.dart';
import 'package:eurokey2/features/location_data/map_utils.dart';
import 'package:eurokey2/features/location_data/user_pos_locator.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/features/user_data_management/user_data_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as d;
import 'package:meta/meta.dart';

part 'location_management_event.dart';

part 'location_management_state.dart';

///Stores location data.
class LocationManagementBloc extends Bloc<LocationManagementEvent, LocationManagementState> {
  final d.Distance _distance = const d.Distance();
  final UserPositionLocator _userLocation = UserPositionLocator();
  final LocationZoomInfo _zoomInfo = LocationZoomInfo();

  late ScreenNavigationBloc _navigationBloc;
  late EUKLocationManager locationManager;


  LocationManagementBloc({required ScreenNavigationBloc navigationBloc}) : super(const LocationManagementDefault()) {
    _navigationBloc = navigationBloc;
    on<OnFocusOnLocation>(_onFocusOnLocation);
    on<OnFocusOnEUKLocation>(_onFocusOnEUKLocation);
    on<OnFocusOnUserPosition>(_onFocusOnUserPosition);
    on<OnMapIsReady>(_onMapIsReady);
    on<OnLoadLocationsFromDatabase>(_onLoadFromDatabase);
    on<OnLoadLocationsFromDatabaseFinished>(_onLoadFromDatabaseFinished);
    on<OnRecalculateLocationsDistance>(_onRecalculateLocationsDistance);
  }

  ///Async constructor for [LocationManagementBloc].
  Future<void> create({required UserDataManager dataManager}) async {
    locationManager = EUKLocationManager(dataManager: dataManager);
    add(OnLoadLocationsFromDatabase());
    await _userLocation.initLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) => _userLocation.updateLocation());
    await _userLocation.updateLocation();
    add(OnFocusOnUserPosition());
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
    add(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom));
  }

  Future<void> _onFocusOnUserPosition(OnFocusOnUserPosition event, emit) async {
    add(OnFocusOnLocation(_userLocation.currentPosition, zoom: _userLocation.zoomAmount));
  }

  Future<void> _onMapIsReady(OnMapIsReady event, emit) async {
    locationManager.clusterManager.setMapId(event.mapController.mapId);

    if (_zoomInfo.wantedPosition == null) return;
    if (_zoomInfo.popupWindow == null) return;

    Future.delayed(const Duration(milliseconds: 400), () => {
      locationManager.windowController.addInfoWindow!(_zoomInfo.popupWindow!, _zoomInfo.wantedPosition!),
        _zoomInfo.clear()
      },
    );
  }

  Future<void> _onLoadFromDatabase(OnLoadLocationsFromDatabase event, emit) async {
    emit(const LocationManagementUpdatingDatabase());
    locationManager.reloadFromDatabase(onFinish: () => add(OnLoadLocationsFromDatabaseFinished()));
  }

  Future<void> _onLoadFromDatabaseFinished(OnLoadLocationsFromDatabaseFinished event, emit) async {
    if (locationManager.hasThrownError) {
      showSnackBar(message: 'Nebylo možné navázat spojení se serverem. Zkuste to prosím později nebo zkontrolujte své nastavení internetu.');
      await Future.delayed(const Duration(milliseconds: 200));
      emit(const LocationManagementDefault());
      return;
    }

    await Future.delayed(Duration(milliseconds: 100 + Random().nextInt(25)));
    emit(const LocationManagementUpdatingFinished());
    await Future.delayed(const Duration(seconds: 3));
    emit(const LocationManagementDefault());
  }

  void _onRecalculateLocationsDistance(OnRecalculateLocationsDistance event, emit) {
    for (final EUKLocationData data in locationManager.locations) {
      final d.LatLng posLocation = d.LatLng(data.lat, data.long);
      final d.LatLng posUser = d.LatLng(_userLocation.currentPosition.latitude, _userLocation.currentPosition.longitude);
      data.updateDistanceFromDevice(_distance.as(d.LengthUnit.Meter, posLocation, posUser) / 1000);
    }
  }

  ScreenNavigationBloc get navigationBloc => _navigationBloc;
  UserPositionLocator get userLocation => _userLocation;
  LatLng? get wantedPosition => _zoomInfo.wantedPosition;
  double? get wantedZoom => _zoomInfo.wantedZoom;
}
