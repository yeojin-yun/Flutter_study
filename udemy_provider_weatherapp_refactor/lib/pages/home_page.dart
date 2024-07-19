import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:udemy_provider_weatherapp_refactor/constants/constant.dart';
import 'package:udemy_provider_weatherapp_refactor/pages/search_page.dart';
import 'package:udemy_provider_weatherapp_refactor/pages/settings_page.dart';
import 'package:udemy_provider_weatherapp_refactor/providers/setting/temp_setting_provider.dart';
import 'package:udemy_provider_weatherapp_refactor/providers/weather/weather_provider.dart';
import 'package:udemy_provider_weatherapp_refactor/repositories/weather_repository.dart';
import 'package:udemy_provider_weatherapp_refactor/services/weather_api_services.dart';
import 'package:udemy_provider_weatherapp_refactor/widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WeatherProvider _weatherProvider;
  late final void Function() _removeListener;

  @override
  void initState() {
    // TODO: implement initState
    //_fetchWeather();
    _weatherProvider = context.read<WeatherProvider>();
    _removeListener = _weatherProvider.addListener(addListener);
    super.initState();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void addListener(WeatherState weatherState) {
    debugPrint('⛔️ addListener');

    if (weatherState.weatherStatus == WeatherStatus.error) {
      errorDialog(context, weatherState.error.errorMessage);
    }
  }

  Widget _showWeather() {
    final state = context.watch<WeatherState>();
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

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          state.weather.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 10),
            Text(
              '(${state.weather.country})',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(state.weather.temp),
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Text(
                  showTemperature(state.weather.tempMin),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  showTemperature(state.weather.tempMax),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Spacer(),
            showIcon(state.weather.icon),
            Expanded(flex: 3, child: formatText(state.weather.description)),
            Spacer(),
          ],
        )
      ],
    );
  }

  String showTemperature(double temperature) {
    final TempUnit tempUnit = context.watch<TempSettingState>().tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }
    return temperature.toStringAsFixed(2) + '℃';
  }

  showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
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
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: _showWeather(),
    );
  }
}
