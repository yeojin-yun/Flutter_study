import 'package:flutter/material.dart';

class Moongchi extends ChangeNotifier {
  final String name;
  final String breed;
  int age;

  Moongchi({
    required this.name,
    required this.breed,
    this.age = 1,
  });

  getAge() {
    age++;
    debugPrint('age = $age');
    notifyListeners();
  }

  resetAge() {
    age = 1;
    notifyListeners();
  }
}
