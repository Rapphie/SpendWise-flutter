import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  BuildContext? _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent tapping outside to dismiss
      builder: (BuildContext context) {
        _context = context; // Save the correct context here
        isDisplayed = true;
        return const Dialog(
          backgroundColor: Colors.transparent, // No background color
          child: Center(
            child: CircularProgressIndicator(), // Only the progress indicator
          ),
        );
      },
    );
  }

  dismiss() {
    if (isDisplayed && _context != null) {
      Navigator.of(_context!).pop(); // Use the stored context to pop the dialog
      isDisplayed = false;
    }
  }
}
