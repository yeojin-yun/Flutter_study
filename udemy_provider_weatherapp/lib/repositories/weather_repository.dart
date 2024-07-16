import 'package:flutter/material.dart';
import 'package:udemy_provider_weatherapp/exceptions/weather_exception.dart';
import 'package:udemy_provider_weatherapp/model/custom_error.dart';
import 'package:udemy_provider_weatherapp/model/direct_geocoding.dart';
import 'package:udemy_provider_weatherapp/model/weather.dart';
import 'package:udemy_provider_weatherapp/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<Weather> fetchWeather(String city) async {
    debugPrint('✅ 3. [repository] fetchWeather');
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      debugPrint('repository: $directGeocoding');

      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);

      ///유저가 입력한 city보다 geocoding을 통해 넘어온 name, country가 더 정확한 경우가 있기 때문에
      ///그 정보로 대체
      final Weather weather = tempWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errorMessage: e.message);
    } catch (e) {
      throw CustomError(errorMessage: e.toString());
    }
  }
}
