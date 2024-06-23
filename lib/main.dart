import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/weather_page.dart';
import 'pages/city_list_page.dart';
import 'pages/onboarding_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routes: {
        '/': (context) => OnboardingPage(),
        '/weather': (context) => WeatherPage(),
        '/city_list': (context) => CityListPage(),
      },
    );
  }
}
