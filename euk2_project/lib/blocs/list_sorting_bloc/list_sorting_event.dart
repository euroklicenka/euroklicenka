part of 'list_sorting_bloc.dart';

@immutable
abstract class ListSortingEvent {}

class OnSortByLocationDistance extends ListSortingEvent {}

class OnFilterLocations extends ListSortingEvent {
  final String searchText;

  OnFilterLocations(this.searchText);
}