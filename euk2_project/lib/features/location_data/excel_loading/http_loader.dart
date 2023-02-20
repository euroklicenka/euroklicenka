
import 'package:http/http.dart';

///Processes the connection between the app and Excel file'S URL address.
class HTTPLoader {
  Future<List<int>> getAsBytes(String url) async {
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {return response.bodyBytes;}
    //TODO Throw error to user when loading was not successful.
    throw new Exception('It was not possible to load the EUK Excel file.');
  }
}
