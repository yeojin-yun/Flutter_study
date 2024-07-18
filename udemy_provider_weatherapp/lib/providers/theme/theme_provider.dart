import 'package:flutter/material.dart';
import 'package:udemy_provider_weatherapp/constants/constant.dart';
import 'package:udemy_provider_weatherapp/providers/weather/weather_provider.dart';

part 'theme_state.dart';

class ThemeProvider with ChangeNotifier {
  ThemeState _state = ThemeState.initialize();
  ThemeState get state => _state;

  void update(WeatherProvider weatherProvider) {
    if (weatherProvider.state.weather.temp > kWarmOrNot) {
      _state = _state.copyWith(appTheme: AppTheme.light);
    } else {
      _state = _state.copyWith(appTheme: AppTheme.dart);
    }
    notifyListeners();
  }
}
