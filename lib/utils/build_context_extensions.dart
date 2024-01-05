// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';

extension ExpandedBuildContext on BuildContext {
  ///Returns TRUE if dark mode is enabled for app.
  bool get isAppInDarkMode {
    return Theme.of(this).colorScheme.brightness == Brightness.dark;
  }
}
