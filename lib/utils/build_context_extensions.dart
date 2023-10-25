import 'package:flutter/material.dart';

extension ExpandedBuildContext on BuildContext {
  ///Returns TRUE if dark mode is enabled for app.
  bool get isAppInDarkMode {
    return Theme.of(this).colorScheme.brightness == Brightness.dark;
  }
}
