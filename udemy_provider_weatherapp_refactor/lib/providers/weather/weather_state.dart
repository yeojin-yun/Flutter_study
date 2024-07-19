// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_provider.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherState {
  final WeatherStatus weatherStatus;
  final Weather weather;
  final CustomError error;
  WeatherState({
    required this.weatherStatus,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initalize() {
    return WeatherState(
        weatherStatus: WeatherStatus.initial,
        weather: Weather.initialize(),
        error: CustomError());
  }

  @override
  bool operator ==(covariant WeatherState other) {
    if (identical(this, other)) return true;

    return other.weatherStatus == weatherStatus &&
        other.weather == weather &&
        other.error == error;
  }

  @override
  int get hashCode =>
      weatherStatus.hashCode ^ weather.hashCode ^ error.hashCode;

  WeatherState copyWith({
    WeatherStatus? weatherStatus,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'WeatherState(weatherStatus: $weatherStatus, weather: $weather, error: $error)';
}
