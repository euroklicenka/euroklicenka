part of 'location_management_bloc.dart';

@immutable
abstract class LocationManagementState {
  const LocationManagementState();
}

class LocationManagementDefault extends LocationManagementState {
  const LocationManagementDefault();
}

class LocationManagementFocusing extends LocationManagementState {
  const LocationManagementFocusing();
}
