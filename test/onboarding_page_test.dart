import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/pages/onboarding_page.dart';

void main() {
  testWidgets('OnboardingPage displays onboarding screens and navigates on completion', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 800);

    // Pump the OnboardingPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: const OnboardingPage(),
        routes: {
          '/weather': (context) => const Scaffold(body: Text('Weather Page')),
        },
      ),
    );

    // Verify the presence of the first onboarding screen
    expect(find.text('Welcome to WeatherNow'), findsOneWidget);
    expect(
        find.text("Stay updated with the current weather conditions in any city "
            "around the world. WeatherNow provides accurate and real-time "
            "weather information at your fingertips."),
        findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // Swipe to the second onboarding screen
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // Verify the presence of the second onboarding screen
    expect(find.text('Choose Your City'), findsOneWidget);
    expect(
        find.text("Select any city to view its current weather. Simply search for "
            "your desired city, and get instant weather updates including "
            "temperature, humidity, and more."),
        findsOneWidget);

    // Swipe to the third onboarding screen
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // Verify the presence of the third onboarding screen
    expect(find.text('Save Your Favorite Cities'), findsOneWidget);
    expect(
        find.text("Add cities to your list and keep track of their weather effortlessly. "
            "Your selected cities are saved in the app's database, so you can "
            "easily access them anytime."),
        findsOneWidget);

    // Tap the "Done" button
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Verify the navigation to the weather page
    expect(find.text('Weather Page'), findsOneWidget);
  });
}
