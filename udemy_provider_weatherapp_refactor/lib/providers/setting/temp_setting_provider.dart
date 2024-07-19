import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
part 'temp_setting_state.dart';

// class TempSettingProvider with ChangeNotifier {
//   TempSettingState _state = TempSettingState.initialize();
//   TempSettingState get state => _state;

//   void toggleSwitch() {
//     _state = _state.copyWith(
//       tempUnit: _state.tempUnit == TempUnit.celsius
//           ? TempUnit.fahrenheit
//           : TempUnit.celsius,
//     );
//     debugPrint('toggle switch = $_state');
//     notifyListeners();
//   }
// }

class TempSettingProvider extends StateNotifier<TempSettingState> {
  TempSettingProvider() : super(TempSettingState.initialize());

  void toggleSwitch() {
    state = state.copyWith(
      tempUnit: state.tempUnit == TempUnit.celsius
          ? TempUnit.fahrenheit
          : TempUnit.celsius,
    );
    debugPrint('toggle switch = $state');
  }
}
