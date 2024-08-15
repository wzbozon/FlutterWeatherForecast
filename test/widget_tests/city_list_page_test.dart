import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/models/city_model.dart';
import 'package:weather_now/pages/city_list_page.dart';
import 'package:weather_now/providers/cities_provider.dart';

void main() {
  Future<List<City>> getMockCitiesList() async {
    final jsonString = await rootBundle.loadString('assets/json/default_cities.json');
    final jsonMap = json.decode(jsonString);
    List<dynamic> citiesJson = jsonMap["cities"];
    List<City> citiesList = citiesJson.map((json) => City.fromMap(json)).take(3).toList();
    return citiesList;
  }

  testWidgets('CityListPage displays correctly', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 800);

    // Define a list of cities to be returned by the mock provider
    final List<City> mockCitiesList = await getMockCitiesList();

    // Pump the WeatherPage widget
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            citiesProvider.overrideWith((ref) async {
              return mockCitiesList;
            }),
          ],
          child: const MaterialApp(
            home: CityListPage(),
          )),
    );

    // Wait for the widget to build and settle
    await tester.pumpAndSettle();

    // Verify that the CityListPage widget is displayed
    expect(find.byType(CityListPage), findsOneWidget);

    // Verify that the CityListPage contains a ListView with cities:
    expect(find.byType(ListView), findsOneWidget);

    // Verify that all cities are displayed in the list
    for (final city in mockCitiesList) {
      expect(find.text(city.name), findsOneWidget);
      expect(find.text('Latitude: ${city.latitude}, Longitude: ${city.longitude}'), findsOneWidget);
    }
  });
}
