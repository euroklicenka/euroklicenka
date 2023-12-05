import 'package:eurokey2/features/location_data/excel_loading/excel_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  test('XLS file should be loaded', () async {
    final _excelParser = ExcelParser();
    const eurokliceLocationsURL =
        'https://www.euroklic.cz/element/simple/documents-to-download/8/3/9ce2559301112481.xlsx?download=true&download_filename=Pruvodce_po_mistech_v_CR_osazenych_Eurozamky_20231020_web.xlsx';

    try {
      final response = await http.get(Uri.parse(eurokliceLocationsURL));

      if (response.statusCode == 200) {
        // parse the downloaded file
        await _excelParser.parse(response.bodyBytes);
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // parse the on disk file
    final String fileData = await rootBundle.loadString(
        'assets/Pruvodce_po_mistech_v_CR_osazenych_Eurozamky_20231020_web.xlsx');

    await _excelParser.parse(utf8.encode(fileData));
    return;
  });
}
