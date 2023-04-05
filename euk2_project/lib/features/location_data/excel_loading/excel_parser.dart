import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

///Parses EUK data from an excel table.
class ExcelParser {

  ///Parses data from an excel file and returns it as a list.
  Future<List<EUKLocationData>> parse(List<int> fileBytes) async {
    if (fileBytes.isEmpty) return [];

    final List<EUKLocationData> locations = [];

    final SpreadsheetDecoder decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: true);
    for (final String table in decoder.tables.keys) {
      for (int i = 1; i < decoder.tables[table]!.rows.length; i++) {
        final List row = decoder.tables[table]!.rows[i];

        if (row[3] == null) continue;
        final List<String> latlng = _toString(row[3]).split(',');

        locations.add(EUKLocationData(
            id: (i - 1).toString(),
            lat: _fromDegreesToDecimals(latlng[0].trim()),
            long: _fromDegreesToDecimals(latlng[1].trim()),
            address: _extractAddress(row[2].toString()),
            region: _toString(row[0]),
            city: _toString(row[1]),
            info: _toString(row[4]),
            ZIP: _extractZipCode(row[2].toString()),
            type: _extractLocationType(_toString(row[2]))));
      }
    }
    return locations;
  }

  ///Converts GPS coordinates from degrees into the decimal format (used by Latitude & Longitude)
  double _fromDegreesToDecimals(String s) {
    final double degrees = double.parse(s.substring(0, s.indexOf('°')));
    final double minutes = double.parse(s.substring(s.indexOf('°') + 1, s.indexOf('\'')));
    final double seconds = double.parse(s.substring(s.indexOf('\'') + 1, s.indexOf('"')));
    return _fromDegreesToDecimal(degrees, minutes, seconds);
  }

  ///Converts GPS coordinates from degrees into the decimal format (used by Latitude & Longitude)
  double _fromDegreesToDecimal(double degree, double minutes, double seconds) {
    return degree + (minutes / 60) + (seconds / 3600);
  }

  ///Extracts a ZIP code (XXX XX number) from a string.
  String _extractZipCode(String address) {
    final RegExp zipCodeRegex = RegExp(r'\b\d{3} \d{2}\b');
    final RegExpMatch? match = zipCodeRegex.firstMatch(address);
    return match?.group(0) ?? '';
  }

  ///Based on text snippets in a string returns a [EUKLocationType].
  EUKLocationType _extractLocationType(String address) {
    if (address.isEmpty) return EUKLocationType.none;
    if (RegExp(r'\bWC\b').firstMatch(address) != null) return EUKLocationType.wc;
    if (RegExp(r'\bPlošina\b').firstMatch(address) != null) return EUKLocationType.platform;
    if (RegExp(r'\bNemocnice\b').firstMatch(address) != null) return EUKLocationType.hospital;
    if (RegExp(r'\bVýtah\b').firstMatch(address) != null) return EUKLocationType.elevator;
    if (RegExp(r'\bBrána\b').firstMatch(address) != null) return EUKLocationType.gate;
    return EUKLocationType.none;
  }

  ///Removes excess information from [address] like location type, city, ZIP
  ///and extra info.
  String _extractAddress(String address) {
    final RegExp exp = RegExp(r'^[^.]*\.\s*(.*?),?\s*\b\d{3} \d{2}\b');
    final Match? match = exp.firstMatch(address);
    return (match != null) ? match.group(1)?.trim() ?? '' : address;
  }

  ///Returns the object as a string, but if it is null, returns a default symbol.
  String _toString(dynamic s) => (s == null) ? '---' : s.toString();
}
