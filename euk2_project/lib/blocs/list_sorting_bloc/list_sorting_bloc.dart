import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:meta/meta.dart';

part 'list_sorting_event.dart';
part 'list_sorting_state.dart';

class ListSortingBloc extends Bloc<ListSortingEvent, ListSortingState> {
  late List<EUKLocationData> _locations;


  ListSortingBloc({required List<EUKLocationData> locations}) : super(ListSortingInitial()) {
    _locations = locations;
    on<OnSortByLocationDistance>(_onSortByLocationDistance);
  }

  void _onSortByLocationDistance(OnSortByLocationDistance event, emit) {
    _locations.sort((a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice));
    emit(ListSortingFinishState());
  }

  List<EUKLocationData> get sortedLocations => _locations;
}
