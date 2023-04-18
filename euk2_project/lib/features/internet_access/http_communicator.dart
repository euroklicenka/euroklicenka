import 'dart:io';

import 'package:euk2_project/features/internet_access/allowed_urls.dart';
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

///Processes the connection between the app and Excel file'S URL address.
///
/// Throws [SocketException] when it fails to connect.
Future<List<int>> getAsBytes({required String url}) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return [];
    }
}

///Open the [url] in an external browser.
Future<void> openURL({required String url}) async {
  if (!await launchUrl(Uri.parse(url))) {
    showSnackBar(message: "'$url' nemohla být otevřena.");
  }
}

///Checks if the device is connected to the internet. If not, shows a warning SnackBar.
Future<void> checkInternetAccess({required String errorMessage}) async {
  try {
    await InternetAddress.lookup(universityOfOstravaURL);
  } on SocketException {
    showSnackBar(message: errorMessage);
  }
}
