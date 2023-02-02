part of 'location_management_bloc.dart';

@immutable
abstract class LocationManagementEvent {}

class OnFocusOnLocation extends LocationManagementEvent {
  final LatLng location;
  final double zoom;
  OnFocusOnLocation(this.location, {required this.zoom});
}
