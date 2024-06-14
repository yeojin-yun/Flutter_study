import 'package:flutter/material.dart';
import 'package:navigator_route/main.dart';

class Routes {
  Routes._(); //더 이상 인스턴스 생성되지 않도록 막기

  static String main = '/';
  static String first = '/first';
  static String second = '/second';

  //위에 property로 선언되어 있어야만 아래에서 생성이 가능
  static final routes = <String, WidgetBuilder>{
    main: (context) => const MyHomePage(),
    first: (context) => const FirstScreen(),
  };
}
