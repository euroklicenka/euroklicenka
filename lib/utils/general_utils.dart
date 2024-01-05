// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';

///Hides the onscreen keyboard if it is visible.
Future<void> hideVirtualKeyboard() async {
  FocusManager.instance.primaryFocus?.unfocus();
  // await Future.delayed(const Duration(milliseconds: 500));
}
