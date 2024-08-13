import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/pages/weather_page.dart';
import 'package:weather_now/providers/weather_provider.dart';
import 'package:weather_now/models/weather_model.dart';

void main() {
  // Mock weather data
  Future<Weather> getMockWeatherData() async {
    final jsonString = await rootBundle.loadString('test/assets/json/weather.json');
    final jsonMap = json.decode(jsonString);
    final weatherData = Weather.fromJson(jsonMap);
    return weatherData;
  }

  testWidgets('WeatherPage displays weather information', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 800);

    // Create a mock provider
    final Weather mockWeatherData = await getMockWeatherData();
    final mockWeatherProvider = AutoDisposeFutureProvider.family<Weather, String>((ref, city) async {
      return mockWeatherData;
    });

    // Pump the WeatherPage widget
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            weatherProvider.overrideWithProvider(mockWeatherProvider.call),
          ],
          child: const MaterialApp(
            home: WeatherPage(),
          )),
    );

    // Wait for the widget to settle
    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(const Duration(seconds: 1));
    }

    // Verify the weather information is displayed
    expect(find.text('Cupertino'), findsOneWidget);
    expect(find.text('15 °C'), findsOneWidget);
    expect(find.text('31 °C'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
  });
}
