import 'package:euk2_project/location_data/data/euk_location_data.dart';
import 'package:euk2_project/location_data/data/test_locations.dart';

/// Stores and works with all EUK Locations.
class EUKLocationDataManager {
  late List<EUKLocationData> _locations;

  EUKLocationDataManager._create() {
    _locations = [];
  }

  /// Creates a new instance of the [EUKLocationDataManager] class.
  /// Is a static method, because later will return a [Future].
  static EUKLocationDataManager create() {
    EUKLocationDataManager m = EUKLocationDataManager._create();

    //TODO Fill the list of locations here with an async method.

    m._locations = testLocations;

    return m;
  }

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;
}
