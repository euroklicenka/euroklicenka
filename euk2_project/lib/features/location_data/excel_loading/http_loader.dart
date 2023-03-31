import 'dart:io';

import 'package:http/http.dart';

///Processes the connection between the app and Excel file'S URL address.
class HTTPLoader {
  Future<List<int>> getAsBytes({required String url, Function()? onFail}) async {
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) { return response.bodyBytes; }
    } on SocketException {
      onFail?.call();
    }
    return [];
  }
}
