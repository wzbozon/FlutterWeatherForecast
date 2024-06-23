import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/weather_page.dart';
import 'pages/city_list_page.dart';
import 'pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool showOnboarding = await shouldShowOnboarding();
  runApp(App(showOnboarding: showOnboarding));
}

Future<bool> shouldShowOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('shownOnboarding') ?? false;
}

class App extends StatelessWidget {
  final bool showOnboarding;

  const App({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      initialRoute: showOnboarding ? '/' : '/weather',
      routes: {
        '/': (context) => OnboardingPage(),
        '/weather': (context) => WeatherPage(),
        '/city_list': (context) => CityListPage(),
      },
    );
  }
}

Future<void> markOnboardingShown() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('shownOnboarding', true);
}
