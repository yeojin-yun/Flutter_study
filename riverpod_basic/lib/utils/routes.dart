import 'package:flutter/material.dart';
import 'package:riverpod_basic/screens/counter_screen.dart';
import 'package:riverpod_basic/screens/profile_screen.dart';
import 'package:riverpod_basic/screens/todo_screen.dart';

class Routes {
  Routes._();

  static String counter = '/counter';
  static String todo = '/todo';
  static String profile = '/profile';

  static final routes = <String, WidgetBuilder>{
    counter: (context) => CounterScreen(),
    todo: (context) => TodoScreen(),
    profile: (context) => ProfileScreen()
  };
}
