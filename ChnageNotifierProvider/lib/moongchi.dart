import 'package:flutter/material.dart';

class Moongchi extends ChangeNotifier {
  final String name = 'Moongchi';
  final String breed = 'Papillon';
  int age = 1;

  upAge() {
    age++;
    notifyListeners();
  }

  resetAge() {
    age = 1;
    notifyListeners();
  }
}
