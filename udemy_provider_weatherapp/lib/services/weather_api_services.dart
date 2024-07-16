import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:udemy_provider_weatherapp/constants/constant.dart';
import 'package:udemy_provider_weatherapp/exceptions/weather_exception.dart';
import 'package:udemy_provider_weatherapp/model/direct_geocoding.dart';
import 'package:udemy_provider_weatherapp/model/weather.dart';
import 'package:udemy_provider_weatherapp/services/http_error_handling.dart';

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  ///1.
  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    debugPrint('✅ 4. [apiService] - getDirectGeocoding');
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appId': dotenv.env['APPID']
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandle(response));
      }
      final responBody = json.decode(response.body);

      ///오픈웨더만의 특별한 에러 케이스이므로 -> 커스텀으로 예외처리
      if (responBody.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }

      final directGeocoding = DirectGeocoding.fromJson(responBody);
      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  ///2. 1번에서 받아온 데이터를 바탕으로 weather 정보 받는 함수
  Future<Weather> getWeather(DirectGeocoding directGeocoing) async {
    debugPrint('✅ 4 [apiService] - directGeocoing');
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoing.lat}',
        'lon': '${directGeocoing.lon}',
        'units': kUnit,
        'appid': dotenv.env['APPID']
      },
    );
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandle(response));
      }

      final weatherJson = json.decode(response.body);
      final Weather weather = Weather.fromJson(weatherJson);
      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
