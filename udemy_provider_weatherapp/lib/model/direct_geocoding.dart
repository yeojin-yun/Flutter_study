// ignore_for_file: public_member_api_docs, sort_constructors_first
class DirectGeocoding {
  final String name;
  final double lat;
  final double lon;
  final String country;
  DirectGeocoding({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final Map<String, dynamic> data = json[0];
    return DirectGeocoding(
        name: data['name'] as String,
        lat: data['lat'] as double,
        lon: data['lon'] as double,
        country: data['country'] as String);
  }

  DirectGeocoding copyWith({
    String? name,
    double? lat,
    double? lon,
    String? country,
  }) {
    return DirectGeocoding(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'DirectGeocoding(name: $name, lat: $lat, lon: $lon, country: $country)';
  }
}
