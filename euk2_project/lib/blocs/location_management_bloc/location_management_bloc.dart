import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/location_data/location_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'location_management_event.dart';

part 'location_management_state.dart';

///Stores location data.
class LocationManagementBloc extends Bloc<LocationManagementEvent, LocationManagementState> {


  late EUKLocationManager locationManager;

  LocationManagementBloc() : super(LocationManagementDefault()) {
    on<OnFocusOnLocation>(onFocusOnLocation);
  }

  Future<void> create() async {
    locationManager = await EUKLocationManager.create();
  }

  Future<void> onFocusOnLocation(OnFocusOnLocation event, emit) async {
    emit(const LocationManagementFocusing());

    //TODO Switch page if not on map.

    await locationManager.windowController.googleMapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(
      event.location, event.zoom,));

    emit(const LocationManagementDefault());
  }
}