import 'dart:io';

import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:http/http.dart';

///Processes the connection between the app and Excel file'S URL address.
class HTTPLoader {
  Future<List<int>> getAsBytes(String url) async {
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) { return response.bodyBytes;}
    } on SocketException {
      showSnackBar(message: 'Nebylo možné navázat spojení se serverem. Zkuste to prosím později.');
    }
    return [];
  }
}
