import 'package:bloc/bloc.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/features/location_data/location_manager.dart';
import 'package:meta/meta.dart';

part 'list_organizing_event.dart';

part 'list_organizing_state.dart';

class ListOrganizingBloc
    extends Bloc<ListOrganizingEvent, ListOrganizingState> {
  late EUKLocationManager _manager;
  late ListOrganizingEvent _currentSort;
  List<EUKLocationData> _organizedLocations = [];
  bool _isReversed = false;

  ListOrganizingBloc({required EUKLocationManager locManager})
      : super(ListOrganizingDefaultState()) {
    _manager = locManager;
    _currentSort = OnSortByLocationDistance();
    on<OnReset>(_onReset);
    on<OnSortByLocationDistance>(_onSortByLocationDistance);
    on<OnSortByAddress>(_onSortByAddress);
    on<OnSortByCity>(_onSortByCity);
    on<OnFilterByText>(_onFilterByText);
    on<OnReverseOrder>(_onReverseOrder);
  }

  void _onFilterByText(OnFilterByText event, emit) {
    emit(ListOrganizingSortingState());
    _updateSortedLocations();
    _organizedLocations = _organizedLocations.where(
      (element) {
        return element.address
                .toLowerCase()
                .contains(event.value.toLowerCase()) ||
            element.city.toLowerCase().contains(event.value.toLowerCase());
      },
    ).toList();

    add(_currentSort);
    emit(ListOrganizingDefaultState());
  }

  void _onSortByLocationDistance(OnSortByLocationDistance event, emit) {
    _sortLocations(
      event: event,
      emit: emit,
      compare: (a, b) => a.distanceFromDevice.compareTo(b.distanceFromDevice),
    );
  }

  void _onSortByAddress(OnSortByAddress event, emit) {
    _sortLocations(
      event: event,
      emit: emit,
      compare: (a, b) => a.address.compareTo(b.address),
    );
  }

  void _onSortByCity(OnSortByCity event, emit) {
    _sortLocations(
      event: event,
      emit: emit,
      compare: (a, b) => a.city.compareTo(b.city),
    );
  }

  void _onReverseOrder(OnReverseOrder event, emit) {
    emit(ListOrganizingSortingState());
    _reverseLocations();
    _isReversed = !_isReversed;
    emit(ListOrganizingDefaultState());
  }

  void _onReset(OnReset event, emit) {
    add(OnSortByLocationDistance());
    add(OnFilterByText(''));
    if (_isReversed) {
      _reverseLocations();
      _isReversed = false;
    }
  }

  void _sortLocations({
    required ListOrganizingEvent event,
    required emit,
    required int Function(EUKLocationData a, EUKLocationData b) compare,
  }) {
    emit(ListOrganizingSortingState());
    _organizedLocations.sort(compare);
    if (_isReversed) _reverseLocations();
    _currentSort = event;
    emit(ListOrganizingDefaultState());
  }

  void _updateSortedLocations() =>
      _organizedLocations = List.from(_manager.locations);
  void _reverseLocations() =>
      _organizedLocations = _organizedLocations.reversed.toList();

  List<EUKLocationData> get organizedLocations => _organizedLocations;
  ListOrganizingEvent get currentSort => _currentSort;
  bool get isReversed => _isReversed;
}
