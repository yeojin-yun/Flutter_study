// ignore_for_file: public_member_api_docs, sort_constructors_first
class Weather {
  final String description;
  final String icon;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String name;
  final String country;
  final DateTime lastUpdated;
  Weather({
    required this.description,
    required this.icon,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.name,
    required this.country,
    required this.lastUpdated,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return Weather(
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      temp: main['temp'] as double,
      tempMin: main['temp_min'] as double,
      tempMax: main['temp_max'] as double,
      name: '',
      country: '',
      lastUpdated: DateTime.now() as DateTime,
    );
  }

  ///null 값을 만들지 않기 위해 사용하는 생성자
  factory Weather.initialize() => Weather(
        description: '',
        icon: '',
        temp: 100.0,
        tempMin: 100.0,
        tempMax: 100.0,
        name: '',
        country: '',
        lastUpdated: DateTime(1970),
      );

  Weather copyWith({
    String? description,
    String? icon,
    double? temp,
    double? tempMin,
    double? tempMax,
    String? name,
    String? country,
    DateTime? lastUpdated,
  }) {
    return Weather(
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temp: temp ?? this.temp,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      name: name ?? this.name,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Weather(description: $description, icon: $icon, temp: $temp, tempMin: $tempMin, tempMax: $tempMax, name: $name, country: $country, lastUpdated: $lastUpdated)';
  }
}
