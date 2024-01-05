// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:url_launcher/url_launcher.dart';

///Open the [url] in an external browser.
Future<void> openURL({required String url}) async {
  if (!await launchUrl(Uri.parse(url))) {
    showSnackBar(message: "'$url' nemohla být otevřena.");
  }
}
