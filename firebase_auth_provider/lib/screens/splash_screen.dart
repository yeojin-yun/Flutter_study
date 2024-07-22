import 'package:flutter/material.dart';

///여기서 분기가 나눠짐
///1. 로그인 페이지
///2. 홈페이지
class SplashScreen extends StatelessWidget {
  static const String routeName = '/';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
