import 'dart:ui';

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
    cityName ??= await _weatherService.getCurrentCity();

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
    return IconButton(
      onPressed: () async {
        final selectedCity = await Navigator.pushNamed(context, '/city_list') as City;
        _fetchWeather(selectedCity.name);
      },
      icon: const Icon(Icons.search, color: Colors.blue, size: 36),
    );
  }

  Widget _buildWeatherInfo() {
    if (_weather == null) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // City name
        Text(
          _weather?.cityName ?? "loading city ...",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        // Date
        Text(
          _weather?.humanReadableDate() ?? "",
          style: const TextStyle(fontSize: 14, color: Colors.black45),
        ),

        // Spacer
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temperature
                Text(
                  '${_weather?.temperature.round()}',
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),

                // Weather condition
                Text(
                  _weather?.mainCondition ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black45),
                ),
              ],
            ),

            // Temperature units
            const Column(children: [
              const Text(
                '\u00B0C',
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 40),
            ]),

            // Animation
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            ),
          ],
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Today',
        style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: false, // hide back button
      actions: [
        _buildCityListButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildWeatherInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
