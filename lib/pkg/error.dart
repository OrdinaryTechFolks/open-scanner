import 'package:flutter/material.dart';
import 'package:open_scanner/main.dart';

class ErrorPackage {
  static void showSnackBar(Error err) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          err.toString(),
        ),
      ),
    );
  }
}
