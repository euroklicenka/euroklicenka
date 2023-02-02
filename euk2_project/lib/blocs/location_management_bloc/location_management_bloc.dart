import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/location_manager.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'location_management_event.dart';

part 'location_management_state.dart';

///Stores location data.
class LocationManagementBloc extends Bloc<LocationManagementEvent, LocationManagementState> {

  final ScreenNavigationBloc navigationBloc;
  late EUKLocationManager locationManager;

  LocationManagementBloc({required this.navigationBloc}) : super(LocationManagementDefault()) {
    on<OnFocusOnLocation>(onFocusOnLocation);
    on<OnFocusOnEUKLocation>(onFocusOnEUKLocation);
  }

  Future<void> create() async {
    locationManager = await EUKLocationManager.create();
  }

  Future<void> onFocusOnLocation(OnFocusOnLocation event, emit) async {
    emit(const LocationManagementFocusing());

    navigationBloc.add(OnSwitchPage.screen(ScreenType.map));
    await Future.delayed(const Duration(seconds: 1));

    await locationManager.windowController.googleMapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(
      event.location, event.zoom,));



    emit(const LocationManagementDefault());
  }

  Future<FutureOr<void>> onFocusOnEUKLocation(OnFocusOnEUKLocation event, emit) async {
    final EUKLocationData data = locationManager.locations.where((d) => d.id == event.locationID).first;
    await onFocusOnLocation(OnFocusOnLocation(LatLng(data.lat, data.long), zoom: event.zoom), emit);
    locationManager.windowController.addInfoWindow!(buildPopUpWindow(data), LatLng(data.lat, data.long));
  }
}