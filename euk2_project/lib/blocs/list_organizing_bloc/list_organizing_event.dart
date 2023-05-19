part of 'list_organizing_bloc.dart';

@immutable
abstract class ListOrganizingEvent {}

class OnSortByLocationDistance extends ListOrganizingEvent {}

class OnFilterByText extends ListOrganizingEvent {
  final String value;

  OnFilterByText(this.value);
}
