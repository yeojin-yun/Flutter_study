import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:udemy_provider_weatherapp/providers/weather/weather_provider.dart';
import 'package:udemy_provider_weatherapp/repositories/weather_repository.dart';
import 'package:udemy_provider_weatherapp/services/weather_api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    _fetchWeather();
    super.initState();
  }

  _fetchWeather() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<WeatherProvider>().fetchWeather('london');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
    );
  }
}
