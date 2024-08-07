import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:udemy_provider_weatherapp_refactor/constants/constant.dart';
import 'package:udemy_provider_weatherapp_refactor/providers/weather/weather_provider.dart';

part 'theme_state.dart';

// class ThemeProvider with ChangeNotifier {
//   ThemeState _state = ThemeState.initialize();
//   ThemeState get state => _state;

//   void update(WeatherProvider weatherProvider) {
//     if (weatherProvider.state.weather.temp > kWarmOrNot) {
//       _state = _state.copyWith(appTheme: AppTheme.light);
//     } else {
//       _state = _state.copyWith(appTheme: AppTheme.dart);
//     }
//     notifyListeners();
//   }
// }

class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initialize());

  @override
  void update(Locator watch) {
    // TODO: implement update
    if (watch<WeatherState>().weather.temp > kWarmOrNot) {
      state = state.copyWith(appTheme: AppTheme.light);
    } else {
      state = state.copyWith(appTheme: AppTheme.dart);
    }
    super.update(watch);
  }
}
