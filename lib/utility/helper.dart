import 'dart:math';

import 'package:flutter/material.dart';

///to send in display notification, message or warning
void snackMessage(
    {required String message,
    Color color = Colors.red,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// for formatting date
String dateFormatter(DateTime date) {
  String newDate = '${date.day}-${date.month}-${date.year}';
  return newDate;
}

/// for generating random color
Color generateRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

/// for generating random string
String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
