import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/location_data/excel_loading/excel_parser.dart';
import 'package:euk2_project/features/location_data/excel_loading/http_loader.dart';
import 'package:euk2_project/features/location_data/map_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// Stores and works with all EUK Locations.
class EUKLocationManager {
  final String locationsURL =
      'https://www.euroklic.cz/element/simple/documents-to-download/4/0/ccff3b38583129f3.xlsx?download=true&download_filename=Pr%C5%AFvodce+po+m%C3%ADstech+%C4%8CR+osazen%C3%BDch+Euroz%C3%A1mky.xlsx';
  final BehaviorSubject<Set<Marker>> _markerStream =
      BehaviorSubject<Set<Marker>>();

  late HTTPLoader _HTTPloader;
  late ExcelParser _excelParser;
  late CustomInfoWindowController _windowController;
  late List<EUKLocationData> _locations;
  late Set<Marker> _markers;


  EUKLocationManager() {
    _HTTPloader = HTTPLoader();
    _excelParser = ExcelParser();
    _windowController = CustomInfoWindowController();
    _locations = [];
    _markers = {};

  }

  ///Disposes of the Popup Window.
  void dispose() {
    _windowController.dispose();
  }

  ///Loads EUK Locations from the built-in URL link and stores them
  ///in the internal list.
  Future<void> reloadFromDatabase() async {
    final List<int> bytes = await _HTTPloader.getAsBytes(locationsURL);
    final List<EUKLocationData> locations = await _excelParser.parse(bytes);
    _locations = locations;
    _buildMarkers();
  }

  Future<void> _buildMarkers() async {
    _markers.clear();

    for (final EUKLocationData loc in _locations) {
      _markers.add(await convertToMarker(loc, windowController));
      _markerStream.sink.add(_markers);
    }
  }

  ///Returns the list of all EUK locations.
  List<EUKLocationData> get locations => _locations;

  Set<Marker> get markers => _markers;

  Stream<Set<Marker>> get markerStream => _markerStream;

  CustomInfoWindowController get windowController => _windowController;




}

