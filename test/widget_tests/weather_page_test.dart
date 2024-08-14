import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/pages/weather_page.dart';
import 'package:weather_now/providers/weather_provider.dart';
import 'package:weather_now/services/i_weather_service.dart';
import '../mocks/mock_weather_service.dart';

void main() {
  testWidgets('WeatherPage displays weather information', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 800);

    // Create a mock provider
    final mockWeatherServiceProvider = Provider<IWeatherService>((ref) {
      return MockWeatherService();
    });

    // Pump the WeatherPage widget
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            weatherServiceProvider.overrideWithProvider(mockWeatherServiceProvider),
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