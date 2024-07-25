import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_basic/models/user_model.dart';

class Apiservice {
  final Dio dio;

  Apiservice({required this.dio}) {
    dio.options.baseUrl = 'https://jsonplaceholder.typicode.com/users';
  }

  Future<List<UserModel>> getUserList() async {
    try {
      final respsonse = await dio.get('');

      // return UserModel.fromJson(respsonse.data);
      if (respsonse.statusCode == 200) {
        return userListFromJson(respsonse.data);
      } else {
        throw Exception('status code not success');
      }
    } catch (e) {
      rethrow;
    }
  }
}
