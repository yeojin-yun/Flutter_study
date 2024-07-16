import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:udemy_provider_weatherapp/pages/home_page.dart';
import 'package:udemy_provider_weatherapp/pages/test.dart';
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
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
