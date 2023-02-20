import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/excel_loading/excel_parser.dart';
import 'package:euk2_project/features/location_data/excel_loading/http_loader.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  late HTTPLoader _loader;
  late ExcelParser _parser;
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;

  EUKLocationManager() {
    _loader = HTTPLoader();
    _parser = ExcelParser();
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};
  }

  /// Creates a new instance of the [EUKLocationManager] class.
  ///
  /// Is a static method, because later will return a [Future].
   Future<void> create() async {
    
    //TODO Fill the list of locations here with an async method.

    final List<int> bytes = await _loader.getAsBytes('https://www.euroklic.cz/element/simple/documents-to-download/4/0/ccff3b38583129f3.xlsx?download=true&download_filename=Pr%C5%AFvodce+po+m%C3%ADstech+%C4%8CR+osazen%C3%BDch+Euroz%C3%A1mky.xlsx');
    final List<EUKLocationData> locations = await _parser.parse(bytes);
    _locations = locations;
    _markers = await convertToMarkers(_locations, _windowController);
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
