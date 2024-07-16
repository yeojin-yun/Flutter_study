import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_basic/models/user_model.dart';

class Apiservice {
  final Dio dio;

  Apiservice({required this.dio}) {
    dio.options.baseUrl = 'https://jsonplaceholder.typicode.com/users';
  }

  getUserList() async {
    try {
      final repsonse = await dio.get('');
      debugPrint('$repsonse');
    } catch (e) {}
  }
}
