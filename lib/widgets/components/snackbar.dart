import 'package:flutter/material.dart';

class Snackbar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static bool _isSnackBarVisible = false; // Track SnackBar visibility
  static String? _previousMessage; // Store the last message

  static void showSnackbar(String message, {int duration = 3}) {
    if (_isSnackBarVisible && _previousMessage == message || message.isEmpty) {
      return; // Prevent showing the same SnackBar while one is visible
    }

    _previousMessage = message; // Update the previous message
    _isSnackBarVisible = true; // Mark SnackBar as visible

    scaffoldMessengerKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: duration), // Adjust duration as needed
          ),
        )
        .closed
        .then((_) {
      // Reset visibility flag when the SnackBar disappears
      _isSnackBarVisible = false;
    });
  }
}
