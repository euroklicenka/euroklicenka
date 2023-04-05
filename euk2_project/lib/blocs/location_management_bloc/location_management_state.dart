part of 'location_management_bloc.dart';

@immutable
abstract class LocationManagementState {
  const LocationManagementState();
}

class LocationManagementDefault extends LocationManagementState {
  const LocationManagementDefault();
}

class LocationManagementUpdatingDatabase extends LocationManagementState {
  const LocationManagementUpdatingDatabase();
}

class LocationManagementUpdatingFinished extends LocationManagementState {
  const LocationManagementUpdatingFinished();
}
