import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('결과 페이지'),
        ),
        body: Center(
          child: Text(
            '성공!',
            style: TextStyle(fontSize: 40),
          ),
        ));
  }
}
