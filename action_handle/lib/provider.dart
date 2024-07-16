import 'package:flutter/material.dart';

enum AppState { initial, loading, success, error }

class AppProvider with ChangeNotifier {
  AppState _state = AppState.initial;
  AppState get state => _state;

  Future<void> getResult(String searchTerm) async {
    _state = AppState.loading;
    notifyListeners();

    Future.delayed(Duration(seconds: 1));

    try {
      if (searchTerm == 'fail') {
        debugPrint('-----fail 입력-------');
        // throw Exception('user type fail');
        throw 'user type fail';
      }

      _state = AppState.success;
      notifyListeners();
    } catch (e) {
      debugPrint('----- [1]catch $e------');
      _state = AppState.error;
      notifyListeners();
    }
  }
}
