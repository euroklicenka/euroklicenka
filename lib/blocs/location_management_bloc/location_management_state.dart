part of 'location_management_bloc.dart';

@immutable
abstract class LocationManagementState {}

class LocationManagementDefaultState extends LocationManagementState {}

class LocationManagementUpdatingDatabaseState extends LocationManagementState {}

class LocationManagementUpdatingFinishedState extends LocationManagementState {}

class LocationManagementLoadingPositionState extends LocationManagementState {}
