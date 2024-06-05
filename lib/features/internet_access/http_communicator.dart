// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

///Open the [url] in an external browser.
Future<void> openURL(BuildContext context, String url) async {
  String cannotOpenUrl = AppLocalizations.of(context)!.cannotOpenUrl(url);

  if (!await launchUrl(Uri.parse(url))) {
    showSnackBar(message: cannotOpenUrl);
  }
}
