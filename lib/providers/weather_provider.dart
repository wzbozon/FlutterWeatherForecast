import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../services/i_weather_service.dart';
import '../services/weather_service.dart';

final weatherServiceProvider = Provider<IWeatherService>((ref) {
  return WeatherService('a38cd3af59a5037bf5d0216e3276eda3');
});

final weatherProvider = FutureProvider.family.autoDispose<Weather, String>((ref, cityName) async {
  final weatherService = ref.watch(weatherServiceProvider);
  Weather weather = await weatherService.getWeather(cityName);
  return weather;
});
