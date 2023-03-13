import 'dart:io';

import 'package:http/http.dart';

///Processes the connection between the app and Excel file'S URL address.
class HTTPLoader {
  Future<List<int>> getAsBytes(String url) async {
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) { return response.bodyBytes;}
    } on SocketException {
      //TODO Throw error to user when loading was not successful.
    }
    return [];
  }
}
