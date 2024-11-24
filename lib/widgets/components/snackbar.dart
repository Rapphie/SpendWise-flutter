import 'package:flutter/material.dart';

class Snackbar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static bool _isSnackBarVisible = false; // Track SnackBar visibility

  static void showSnackBar(String message, {int duration = 2}) {
    if (_isSnackBarVisible) return; // Prevent showing another SnackBar

    _isSnackBarVisible = true;
    scaffoldMessengerKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: duration), // Adjust duration as needed
          ),
        )
        .closed
        .then((_) {
      // Reset the flag when the SnackBar disappears
      _isSnackBarVisible = false;
    });
  }
}
