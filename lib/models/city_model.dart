class City {
  final String name;
  final double latitude;
  final double longitude;

  City({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
