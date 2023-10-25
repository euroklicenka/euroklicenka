import 'package:flutter/material.dart';

///Allows showing a [SnackBar] anywhere in the application.
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

///Shows a [SnackBar] on the screen, displaying the text from [message].
void showSnackBar({required String message}) {
  final SnackBar snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
        label: 'OK',
        onPressed: () => snackBarKey.currentState?.removeCurrentSnackBar(),
    ),
  );
  snackBarKey.currentState?.showSnackBar(snackBar);
}
