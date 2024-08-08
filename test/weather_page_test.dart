import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/main.dart';
import 'package:weather_now/pages/weather_page.dart';
import 'package:weather_now/providers/weather_provider.dart';
import 'package:weather_now/models/weather_model.dart';

void main() {
  Future<void> takeScreenshot(WidgetTester tester, String name) async {
    final directory = Directory('screenshots');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final file = File('${directory.path}/$name.png');
    final bytes = await tester.binding.takeScreenshot();
    await file.writeAsBytes(bytes);
  }

  testWidgets('MyWidget has a title and message', (tester) async {
    // Create a mock provider
    final mockWeatherProvider = AutoDisposeFutureProvider.family<Weather, String>((ref, city) async {
      final jsonString = await rootBundle.loadString('mocks/weather.json');
      final jsonMap = json.decode(jsonString);
      final weatherData = Weather.fromJson(jsonMap);

      return weatherData;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherProvider.overrideWithProvider(mockWeatherProvider),
        ],
        child: const App(showOnboarding: false),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    try {
      final titleFinder = find.text('Today');
      expect(titleFinder, findsOneWidget);

      final cityNameFinder = find.text('Cupertino');
      expect(cityNameFinder, findsOneWidget);
    } catch (e) {
      await takeScreenshot(tester, 'failing_test');
      rethrow;
    }
  });
}
