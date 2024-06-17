import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/components/title_widget.dart';
import 'package:flutter_weather_forecast/components/animated_color_box.dart';
import 'package:flutter_weather_forecast/components/animated_text.dart';

import 'pages/weather_page.dart';
import 'pages/add_city_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddCityPage(),
    );
  }
}

