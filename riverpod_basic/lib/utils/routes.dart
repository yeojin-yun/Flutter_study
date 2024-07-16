import 'package:flutter/material.dart';
import 'package:riverpod_basic/screens/counter_screen.dart';
import 'package:riverpod_basic/screens/jsonplaceholder_screen.dart';
import 'package:riverpod_basic/screens/profile_screen.dart';
import 'package:riverpod_basic/screens/proxy_screen.dart';
import 'package:riverpod_basic/screens/todo_screen.dart';

class Routes {
  Routes._();

  static String counter = '/counter';
  static String todo = '/todo';
  static String profile = '/profile';
  static String proxy = '/proxy';
  static String json = '/json';

  static final routes = <String, WidgetBuilder>{
    counter: (context) => CounterScreen(),
    todo: (context) => TodoScreen(),
    profile: (context) => ProfileScreen(),
    proxy: (context) => ProxyScreen(),
    json: (context) => JsonPlaceholderScreen()
  };
}
