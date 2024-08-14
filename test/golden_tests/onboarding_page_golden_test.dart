import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:weather_now/pages/onboarding_page.dart';

void main() {
  testGoldens('OnboardingPage golden test', (tester) async {
    await loadAppFonts();

    await tester.pumpWidgetBuilder(
      const MaterialApp(
        home: OnboardingPage(),
      ),
      surfaceSize: const Size(500, 800),
    );

    await screenMatchesGolden(tester, 'onboarding_page_golden');
  });
}
