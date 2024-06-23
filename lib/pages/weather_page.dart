import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('a38cd3af59a5037bf5d0216e3276eda3');
  Weather? _weather;

  // fetch weather
  _fetchWeather(String? cityName) async {
    // get current city
    if (cityName == null) {
      cityName = await _weatherService.getCurrentCity();
    }

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/lottie/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/lottie/cloud.json';
      case 'fog':
        return 'assets/lottie/foggy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/lottie/rain.json';
      case 'thunderstorm':
        return 'assets/lottie/thunder.json';
      case 'clear':
        return 'assets/lottie/sunny.json';
      default:
        return 'assets/lottie/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather(null);
  }

  Widget _buildCityListButton() {
    return ElevatedButton(
      onPressed: () async {
        final selectedCity = await Navigator.pushNamed(context, '/city_list') as City;
        _fetchWeather(selectedCity.name);
      },
      child: Text('Select City'),
    );
  }

  Widget _buildWeatherInfo() {
    if (_weather == null) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // city name
        Text(
          _weather?.cityName ?? "loading city ...",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),

        // animation
        Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

        // temperature
        Text('${_weather?.temperature.round()}\u00B0C'),

        // weather condition
        Text(_weather?.mainCondition ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherNow'),
        automaticallyImplyLeading: false, // hide back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherInfo(),
              _buildCityListButton(),
            ],
          ),
        ),
      ),
    );
  }
}
