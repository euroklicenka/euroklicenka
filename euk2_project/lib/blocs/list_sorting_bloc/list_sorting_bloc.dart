import 'package:bloc/bloc.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/features/location_data/location_manager.dart';
import 'package:meta/meta.dart';

part 'list_sorting_event.dart';
part 'list_sorting_state.dart';

class ListSortingBloc extends Bloc<ListSortingEvent, ListSortingState> {
  late EUKLocationManager _manager;  //Do NOT use for sorting. Is only a reference. Use sortedLocations instead.
  List<EUKLocationData> _sortedLocations = [];

  ListSortingBloc({required EUKLocationManager locManager}) : super(ListSortingInitial()) {
    _manager = locManager;
    on<OnSortByLocationDistance>(_onSortByLocationDistance);
  }

  void _onSortByLocationDistance(OnSortByLocationDistance event, emit) {
    _updateSortedLocations();
    _sortedLocations.sort((a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice));
    emit(ListSortingFinishState());
  }

  void _updateSortedLocations() => _sortedLocations = List.from(_manager.locations);

  List<EUKLocationData> get sortedLocations => _sortedLocations;
}
