import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:udemy_provider_weatherapp/pages/home_page.dart';
import 'package:udemy_provider_weatherapp/pages/test.dart';
import 'package:udemy_provider_weatherapp/providers/setting/temp_setting_provider.dart';
import 'package:udemy_provider_weatherapp/providers/theme/theme_provider.dart';
import 'package:udemy_provider_weatherapp/providers/weather/weather_provider.dart';
import 'package:udemy_provider_weatherapp/repositories/weather_repository.dart';
import 'package:udemy_provider_weatherapp/services/weather_api_services.dart';
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
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
        ChangeNotifierProvider<TempSettingProvider>(
          create: (context) => TempSettingProvider(),
        ),
        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (BuildContext context, WeatherProvider weatherProvider,
              ThemeProvider? previous) {
            return previous!..update(weatherProvider);
          },
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
