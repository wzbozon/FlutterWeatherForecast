import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/models/city_model.dart';

void main() {
  group('City', () {
    test('should create a City instance', () {
      final city = City(name: 'New York', latitude: 40.7128, longitude: -74.0060);

      expect(city.name, 'New York');
      expect(city.latitude, 40.7128);
      expect(city.longitude, -74.0060);
    });

    test('should convert City instance to map', () {
      final city = City(name: 'New York', latitude: 40.7128, longitude: -74.0060);
      final cityMap = city.toMap();

      expect(cityMap, {
        'name': 'New York',
        'latitude': 40.7128,
        'longitude': -74.0060,
      });
    });

    test('should create City instance from map', () {
      final cityMap = {
        'name': 'New York',
        'latitude': 40.7128,
        'longitude': -74.0060,
      };
      final city = City.fromMap(cityMap);

      expect(city.name, 'New York');
      expect(city.latitude, 40.7128);
      expect(city.longitude, -74.0060);
    });
  });
}
