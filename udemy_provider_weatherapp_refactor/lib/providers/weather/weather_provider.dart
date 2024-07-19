// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:udemy_provider_weatherapp_refactor/model/custom_error.dart';
import 'package:udemy_provider_weatherapp_refactor/model/weather.dart';
import 'package:udemy_provider_weatherapp_refactor/repositories/weather_repository.dart';

part 'weather_state.dart';

// class WeatherProvider extends ChangeNotifier {
//   WeatherState _state = WeatherState.initalize();

//   WeatherProvider({required this.weatherRepository});

//   WeatherState get state => _state;

//   final WeatherRepository weatherRepository;

//   fetchWeather(String city) async {
//     debugPrint('✅ 2. [provider] fetchWeather');
//     _state = _state.copyWith(weatherStatus: WeatherStatus.loading);
//     notifyListeners();

//     try {
//       final Weather weather = await weatherRepository.fetchWeather(city);
//       _state = _state.copyWith(
//           weather: weather, weatherStatus: WeatherStatus.loaded);
//       debugPrint('✅ 5. [성공] $_state');
//       notifyListeners();
//     } on CustomError catch (e) {
//       _state = _state.copyWith(error: e, weatherStatus: WeatherStatus.error);
//       debugPrint('✅ 5. [예외] $_state');
//       notifyListeners();
//     }
//   }
// }
class WeatherProvider extends StateNotifier<WeatherState> with LocatorMixin {
  WeatherProvider() : super(WeatherState.initalize());

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(weatherStatus: WeatherStatus.loading);

    try {
      final Weather weather =
          await read<WeatherRepository>().fetchWeather(city);
      state =
          state.copyWith(weather: weather, weatherStatus: WeatherStatus.loaded);
      debugPrint('✅ 5. [성공] $state');
    } on CustomError catch (e) {
      state = state.copyWith(error: e, weatherStatus: WeatherStatus.error);
      debugPrint('✅ 5. [예외] $state');
    }
  }
}
