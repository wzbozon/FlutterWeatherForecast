import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:weather_now/pages/weather_page.dart';
import 'package:weather_now/providers/weather_provider.dart';
import '../mocks/mock_weather_service.dart';

void main() {
  testGoldens('WeatherPage golden test', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 800);

    await loadAppFonts();

    final Widget weatherPage = ProviderScope(
      overrides: [
        weatherServiceProvider.overrideWith((ref) {
          return MockWeatherService();
        }),
      ],
      child: const MaterialApp(
        home: WeatherPage(),
      ),
    );

    await tester.pumpWidget(weatherPage);

    // Wait for the widget to settle
    for (int i = 0; i < 5; i++) {
      // Because pumpAndSettle doesn't work with the Riverpod
      await tester.pump(const Duration(seconds: 1));
    }

    expect(find.byType(WeatherPage), matchesGoldenFile('goldens/weather_page_golden.png'));
  });
}
