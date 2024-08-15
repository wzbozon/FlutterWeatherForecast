import 'package:weather_now/models/weather_model.dart';

abstract class IWeatherService {
  Future<Weather> getWeather(String cityName);

  Future<String> getCurrentCity();
}
