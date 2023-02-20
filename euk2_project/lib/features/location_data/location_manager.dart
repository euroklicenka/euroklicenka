import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/data/test_locations.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;

  EUKLocationManager._create() {
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};
  }

  /// Creates a new instance of the [EUKLocationManager] class.
  ///
  /// Is a static method, because later will return a [Future].
  static Future<EUKLocationManager> create() async {
    final EUKLocationManager m = EUKLocationManager._create();

    //TODO Fill the list of locations here with an async method.

    m._locations = testLocations;
    m._markers = await convertToMarkers(m._locations, m._windowController);

    return m;
  }

  ///Disposes of the Popup Window.
  void dispose() {
    _windowController.dispose();
  }

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;
  Set<Marker> get markers => _markers;
  CustomInfoWindowController get windowController => _windowController;
}
