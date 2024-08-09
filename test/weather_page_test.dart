import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/main.dart';
import 'package:weather_now/pages/weather_page.dart';
import 'package:weather_now/providers/weather_provider.dart';
import 'package:weather_now/models/weather_model.dart';

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = Size(1800, 2400);

    // Create a mock provider
    final mockWeatherProvider = AutoDisposeFutureProvider.family<Weather, String>((ref, city) async {
      final jsonString = await rootBundle.loadString('test/assets/json/weather.json');
      final jsonMap = json.decode(jsonString);
      final weatherData = Weather.fromJson(jsonMap);

      return weatherData;
    });

    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            weatherProvider.overrideWithProvider(mockWeatherProvider),
          ],
          child: const MaterialApp(
            home: WeatherPage(),
          )),
    );

    // Wait for the widget to settle
    // https://stackoverflow.com/questions/67186472/error-pumpandsettle-timed-out-maybe-due-to-riverpod
    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(Duration(seconds: 1));
    }

    final titleFinder = find.text('Today');
    expect(titleFinder, findsOneWidget);

    final cityNameFinder = find.text('Cupertino');
    expect(cityNameFinder, findsOneWidget);

    final minTemperatureFinder = find.text('15 °C');
    expect(minTemperatureFinder, findsOneWidget);

    final maxTemperatureFinder = find.text('31 °C');
    expect(maxTemperatureFinder, findsOneWidget);

    final weatherConditionFinder = find.text('Clear');
    expect(weatherConditionFinder, findsOneWidget);
  });
}
