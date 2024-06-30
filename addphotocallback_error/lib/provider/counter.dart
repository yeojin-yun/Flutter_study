import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int number = 0;

  void increment() {
    number++;
    notifyListeners();
  }
}
