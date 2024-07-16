import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:udemy_provider_weatherapp/pages/search_page.dart';
import 'package:udemy_provider_weatherapp/providers/weather/weather_provider.dart';
import 'package:udemy_provider_weatherapp/repositories/weather_repository.dart';
import 'package:udemy_provider_weatherapp/services/weather_api_services.dart';
import 'package:udemy_provider_weatherapp/widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WeatherProvider _weatherProvider;
  @override
  void initState() {
    // TODO: implement initState
    //_fetchWeather();
    _weatherProvider = context.read<WeatherProvider>();
    _weatherProvider.addListener(addListener);
    super.initState();
  }

  @override
  void dispose() {
    _weatherProvider.removeListener(addListener);
    super.dispose();
  }

  void addListener() {
    debugPrint('⛔️ addListener');

    ///watch는 안됨 -> button을 누를 때 watch로 처리하면 안되는 것과 같은 이치
    final WeatherState ws = context.read<WeatherProvider>().state;
    if (ws.weatherStatus == WeatherStatus.error) {
      errorDialog(context, ws.error.errorMessage);
    }
  }

  Widget _showWeather() {
    final state = context.watch<WeatherProvider>().state;
    debugPrint('✅ ✅ ${state.weatherStatus} | ${state.weather.name}');
    if (state.weatherStatus == WeatherStatus.initial) {
      return Center(
        child: Text(
          'Select the city',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    if (state.weatherStatus == WeatherStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.weatherStatus == WeatherStatus.error &&
        state.weather.name == '') {
      return Center(
        child: Text(
          'Select the city',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return Center(
      child: Text('${state.weather.name}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
              onPressed: () async {
                String? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
                if (result != null) {
                  debugPrint('✅ 1. onPressed');
                  context.read<WeatherProvider>().fetchWeather(result);
                }
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: _showWeather(),
    );
  }
}
