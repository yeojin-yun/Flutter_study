import 'package:flutter/material.dart';

import 'package:udemy_provider_weatherapp/model/custom_error.dart';
import 'package:udemy_provider_weatherapp/model/weather.dart';
import 'package:udemy_provider_weatherapp/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherState _state = WeatherState.initalize();

  WeatherProvider({required this.weatherRepository});

  WeatherState get state => _state;

  final WeatherRepository weatherRepository;

  fetchWeather(String city) async {
    debugPrint('✅ 2. [provider] fetchWeather');
    _state = _state.copyWith(weatherStatus: WeatherStatus.loading);
    notifyListeners();

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);
      _state = _state.copyWith(
          weather: weather, weatherStatus: WeatherStatus.loaded);
      debugPrint('✅ 5. [성공] $_state');
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(error: e, weatherStatus: WeatherStatus.error);
      debugPrint('✅ 5. [예외] $_state');
      notifyListeners();
    }
  }
}
