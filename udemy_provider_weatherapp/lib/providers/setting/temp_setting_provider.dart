import 'package:flutter/material.dart';
part 'temp_setting_state.dart';

class TempSettingProvider with ChangeNotifier {
  TempSettingState _state = TempSettingState.initialize();
  TempSettingState get state => _state;

  void toggleSwitch() {
    _state = _state.copyWith(
      tempUnit: _state.tempUnit == TempUnit.celsius
          ? TempUnit.fahrenheit
          : TempUnit.celsius,
    );
    debugPrint('toggle switch = $_state');
    notifyListeners();
  }
}
