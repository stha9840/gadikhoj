import 'package:flutter/material.dart';

void showMySnackBar({
  required BuildContext context,
  required String message,
  // 1. Add an optional, nullable 'color' parameter.
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        // Make sure text is always white and readable.
        style: const TextStyle(color: Colors.white),
      ),
      // 2. Use the provided color. If it's null, use a default dark color.
      backgroundColor: color ?? Colors.black87,
      // Some nice UI improvements:
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}