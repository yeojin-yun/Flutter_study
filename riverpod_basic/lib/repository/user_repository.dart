// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:riverpod_basic/models/user_model.dart';
import 'package:riverpod_basic/services/apiservice.dart';

class UserRepository {
  final Apiservice apiservice;
  UserRepository({
    required this.apiservice,
  });

  Future<List<UserModel>> getUserList() async {
    try {
      List<UserModel> userList = await apiservice.getUserList();
      debugPrint('userList: $userList');
      return userList;
    } catch (e) {
      rethrow;
    }
  }
}
