import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

///Parses EUK data from an excel table.
class ExcelParser {
  ///Parses data from an excel file and returns it as a list.
  Future<List<EUKLocationData>> parse(List<int> fileBytes) async {
    final List<EUKLocationData> locations = [];

    final SpreadsheetDecoder decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: true);
    for (final String table in decoder.tables.keys) {
      for (int i = 1; i < decoder.tables[table]!.rows.length; i++) {
        final List row = decoder.tables[table]!.rows[i];
        locations.add(EUKLocationData(
            id: (i - 1).toString(),
            lat: 0,
            long: 0, //TODO Add LATLONG parser
            address: row[2].toString(),
            region: row[0].toString(),
            city: row[1].toString(),
            info: row[4].toString(),
            ZIP: '', //TODO Add a ZIP parser from the address
            type: EUKLocationType.none)); //TODO Add a location parser
      }
    }
    return locations;
  }
}
