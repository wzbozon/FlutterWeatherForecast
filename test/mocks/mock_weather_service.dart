import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:weather_now/models/weather_model.dart';
import 'package:weather_now/services/i_weather_service.dart';

class MockWeatherService implements IWeatherService {
  @override
  Future<Weather> getWeather(String cityName) async {
    final jsonString = await rootBundle.loadString('test/assets/json/weather.json');
    final jsonMap = json.decode(jsonString);
    final weatherData = Weather.fromJson(jsonMap);
    return weatherData;
  }

  @override
  Future<String> getCurrentCity() async {
    return "Cupertino";
  }
}
