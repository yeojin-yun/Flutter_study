import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_basic/services/apiservice.dart';
import 'package:riverpod_basic/utils/style.dart';

class JsonPlaceholderScreen extends StatelessWidget {
  JsonPlaceholderScreen({super.key});
  Apiservice apiservice = Apiservice(dio: Dio());
  void test() {
    apiservice.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      appBar: AppBar(
        title: const Text('jsonplaceholder'),
      ),
      body: Center(
        child: Text(
          '카운터',
          style: style.bodyStyle,
        ),
      ),
    );
  }
}
