part of 'location_management_bloc.dart';

@immutable
abstract class LocationManagementEvent {}

class OnFocusOnLocation extends LocationManagementEvent {
  final LatLng location;
  final double zoom;
  OnFocusOnLocation(this.location, {required this.zoom});
}

class OnFocusOnEUKLocation extends LocationManagementEvent {
  final String locationID;
  final double zoom;
  OnFocusOnEUKLocation(this.locationID, {required this.zoom});
}
class OnMapIsReady extends LocationManagementEvent {
  final GoogleMapController mapController;
  OnMapIsReady(this.mapController);
}

class OnFocusOnUserPosition extends LocationManagementEvent {}
class OnLoadLocationsFromDatabase extends LocationManagementEvent {}
