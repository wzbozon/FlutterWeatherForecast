import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/pages/add_city_page.dart';

void main() {
  testWidgets('AddCityPage displays correctly', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 800);

    // Pump the AddCityPage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: AddCityPage(),
      ),
    );

    // Wait for the widget to build and settle
    await tester.pumpAndSettle();

    // Verify that the widget is displayed
    expect(find.byType(AddCityPage), findsOneWidget);

    // Verify TextFields
    expect(find.byType(TextField), findsNWidgets(3));

    // Verify a button to save the city
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}