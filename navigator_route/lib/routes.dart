import 'package:flutter/material.dart';
import 'package:navigator_route/main.dart';
import 'package:navigator_route/pop_scope.dart';

class Routes {
  Routes._(); //더 이상 인스턴스 생성되지 않도록 막기

  static String main = '/';
  static String nav = '/nav';
  static String first = '/first';
  static String second = '/second';
  static String popScope = '/popScope';
  static String popScopeSub1 = '/popScopeSub1';
  static String popScopeSub2 = '/popScopeSub2';

  //위에 property로 선언되어 있어야만 아래에서 생성이 가능
  static final routes = <String, WidgetBuilder>{
    main: (context) => const HomeScreen(),
    nav: (context) => const NavigatorScreen(),
    first: (context) => const FirstScreen(),
    popScope: (context) => const PopScopeScreen(),
    popScopeSub1: (context) => const PopScopeSubScreen1(),
    popScopeSub2: (context) => const PopScopeSubScreen2(),
  };
}
