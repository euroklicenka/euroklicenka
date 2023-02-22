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
            long: 0,
        //     for (var row in table.rows) {
        // var gpsCoords = row[3]; // 4 sloupec GPS soradnice z excelu
        // var latLng = convertGpsToLatLng(gpsCoords);
        // TODO String gpsCoords = "50°5'11.124\", 14°25'4.031\"";
        // }
        //
        //
        //     LatLng convertGpsToLatLng(String gpsCoords)
        // {
        //   var parts = gpsCoords.split(', ');
        //
        //   // Extract the degrees, minutes, and seconds for the latitude
        //   var latDegrees = int.parse(
        //       parts[0].substring(0, parts[0].indexOf('°')));
        //   var latMinutes = int.parse(parts[0].substring(
        //       parts[0].indexOf('°') + 1, parts[0].indexOf('\'')));
        //   var latSeconds = double.parse(parts[0].substring(
        //       parts[0].indexOf('\'') + 1, parts[0].indexOf('"')));
        //
        //   // Extract the degrees, minutes, and seconds for the longitude
        //   var lngDegrees = int.parse(
        //       parts[1].substring(0, parts[1].indexOf('°')));
        //   var lngMinutes = int.parse(parts[1].substring(
        //       parts[1].indexOf('°') + 1, parts[1].indexOf('\'')));
        //   var lngSeconds = double.parse(parts[1].substring(
        //       parts[1].indexOf('\'') + 1, parts[1].indexOf('"')));
        //
        //   // Convert  degrees, minutes, and seconds to decimal degrees for LatLng
        //   var latitude = GeolocatorPlatform.instance
        //       .fromDMS(latDegrees, latMinutes, latSeconds)
        //       .latitude;
        //   var longitude = GeolocatorPlatform.instance
        //       .fromDMS(lngDegrees, lngMinutes, lngSeconds)
        //       .longitude;
        //
        //   return LatLng(latitude, longitude);
        // }
            address: row[2].toString(),
            region: row[0].toString(),
            city: row[1].toString(),
            info: row[4].toString(),
            ZIP: '',
      //
      //       var zipCodes = <String>[];
      //
      //   for (var row in table.rows) {
      //   var address = row[2].value; // adressa na 2 indexu
      //   var zipCode = extractZipCode(address); //parametr adressy do metody extractZipCode
      //   zipCodes.add(zipCode);
      //   }
      //
      //       print(zipCodes);
      // }
      //
      // String extractZipCode(String address) {
      //   var zipCodeRegex = RegExp(
      //       r'\b\d{5}\b'); // regresní metoda, hleda v celem stringu 5 čiselny diggit odpovidající ZIP codu, který je oddělený napriklad whitespace,punctuation..
      //   var match = zipCodeRegex.firstMatch(address);
      //   return match?.group(0) ??
      //       ''; // pokus nenajde pattern vratí prázdný string
      // }
            type: EUKLocationType.none)); //TODO Add a location parser
      }
    }
    return locations;
  }
}







