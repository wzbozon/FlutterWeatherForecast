import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_now/services/weather_service.dart';
import 'weather_service_test.mocks.dart';

// Mock classes
@GenerateMocks([http.Client])

// Mock weather data
Future<Map<String, dynamic>> getMockWeather() async {
  final jsonString = await rootBundle.loadString('test/assets/json/weather.json');
  final jsonMap = json.decode(jsonString);
  return jsonMap;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeatherService', () {
    late WeatherService weatherService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      weatherService = WeatherService('api_key', client: mockClient);
    });

    test('getWeather returns Weather object', () async {
      final mockWeather = await getMockWeather();
      const urlString = 'http://api.openweathermap.org/data/2.5/weather?'
          'q=Cupertino&appid=api_key&units=metric';

      when(
        mockClient.get(Uri.parse(urlString)),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode(mockWeather),
          200,
        ),
      );

      final weather = await weatherService.getWeather('Cupertino');

      expect(weather.name, 'Cupertino');
      expect(weather.main.temp, 26.13);
    });

    test('getWeather throws an exception', () async {
      when(
        mockClient.get(any),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => weatherService.getWeather('UnknownCity'), throwsException);
    });
  });
}
