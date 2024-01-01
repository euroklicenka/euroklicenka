import 'package:flutter/material.dart';

///Hides the onscreen keyboard if it is visible.
Future<void> hideVirtualKeyboard() async {
  FocusManager.instance.primaryFocus?.unfocus();
  // await Future.delayed(const Duration(milliseconds: 500));
}
