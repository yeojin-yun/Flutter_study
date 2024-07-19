import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:udemy_provider_weatherapp_refactor/pages/home_page.dart';

import 'package:udemy_provider_weatherapp_refactor/providers/setting/temp_setting_provider.dart';
import 'package:udemy_provider_weatherapp_refactor/providers/theme/theme_provider.dart';
import 'package:udemy_provider_weatherapp_refactor/providers/weather/weather_provider.dart';
import 'package:udemy_provider_weatherapp_refactor/repositories/weather_repository.dart';
import 'package:udemy_provider_weatherapp_refactor/services/weather_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.

  // // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///WeatherRepository가 위젯 트리상에 필요하기 때문에 Provider로 감싸서 선언
        Provider<WeatherRepository>(
          create: (context) => WeatherRepository(
            weatherApiServices: WeatherApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        StateNotifierProvider<WeatherProvider, WeatherState>(
          create: (context) {
            return WeatherProvider();
          },
        ),
        StateNotifierProvider<TempSettingProvider, TempSettingState>(
          create: (context) => TempSettingProvider(),
        ),
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (context) => ThemeProvider(),
        )
      ],
      builder: (context, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: context.watch<ThemeState>().appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
