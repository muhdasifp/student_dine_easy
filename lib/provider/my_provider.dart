import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool isLoading = false;

  toggle() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
