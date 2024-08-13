import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/models/weather_model.dart';

// Mock weather data
Future<Weather> getMockWeather() async {
  final jsonString = await rootBundle.loadString('test/assets/json/weather.json');
  final jsonMap = json.decode(jsonString);
  return Weather.fromJson(jsonMap);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Weather', () {
    test('should create a Weather object from JSON', () async {
      final weather = await getMockWeather();

      expect(weather.coord.lon, -122.0322);
      expect(weather.coord.lat, 37.323);
      expect(weather.weather[0].main, 'Clear');
      expect(weather.weather[0].description, 'clear sky');
      expect(weather.weather[0].icon, '01d');
      expect(weather.base, 'stations');
      expect(weather.main.temp, 26.13);
      expect(weather.main.feelsLike, 26.13);
      expect(weather.main.tempMin, 14.87);
      expect(weather.main.tempMax, 31.14);
      expect(weather.main.pressure, 1012);
      expect(weather.main.humidity, 50);
      expect(weather.visibility, 10000);
      expect(weather.wind.speed, 3.6);
      expect(weather.wind.deg, 350);
      expect(weather.clouds.all, 0);
      expect(weather.dt, 1719165045);
      expect(weather.sys.type, 2);
      expect(weather.sys.id, 2083582);
      expect(weather.sys.country, 'US');
      expect(weather.sys.sunrise, 1719146908);
      expect(weather.sys.sunset, 1719199943);
      expect(weather.timezone, -25200);
      expect(weather.id, 5341145);
      expect(weather.name, 'Cupertino');
      expect(weather.cod, 200);
    });

    test('should return human-readable date', () async {
      final weather = await getMockWeather();
      final date = weather.humanReadableDate();

      // Assuming humanReadableDate returns a formatted date string
      expect(date, isNotNull);
      expect(date, isA<String>());
    });
  });
}
