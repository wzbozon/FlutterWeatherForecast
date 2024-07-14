import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/value_widget.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../providers/city_name_provider.dart';
import '../providers/weather_provider.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  Weather? _weather;

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

  Widget _buildCityListButton() {
    return IconButton(
      onPressed: () async {
        final selectedCity = await Navigator.pushNamed(context, '/city_list') as City;
        ref.read(cityNameProvider.notifier).updateCityName(selectedCity.name);
      },
      icon: const Icon(Icons.search, color: Colors.blue, size: 36),
    );
  }

  Widget _buildCityName() {
    return Text(
      _weather?.name ?? "loading city ...",
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDate() {
    return Text(
      _weather?.humanReadableDate() ?? "",
      style: const TextStyle(fontSize: 14, color: Colors.black45),
    );
  }

  Widget _buildTempCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temperature
            Row(
              children: [
                Text(
                  '${_weather?.main.temp.round()}',
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Column(
                  children: [
                    Text(
                      '\u00B0C',
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),

            // Weather condition
            Text(
              _weather?.weather[0].main ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black45),
            ),
          ],
        ),

        // Animation
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Lottie.asset(getWeatherAnimation(_weather?.weather[0].main)),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo() {
    if (_weather == null) {
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // City name
          _buildCityName(),
      
          // Date
          _buildDate(),
      
          // Spacer
          const SizedBox(height: 20),
      
          // Temperature and condition
          _buildTempCondition(),
      
          // Spacer
          const SizedBox(height: 20),
      
          // Spacer
          const SizedBox(height: 8),
      
          // Info collection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueWidget(title: 'Humidity', value: '${_weather?.main.humidity} %'),
              const SizedBox(width: 8),
              ValueWidget(title: 'Temp min', value: '${_weather?.main.tempMin.round()} \u00B0C'),
              const SizedBox(width: 8),
              ValueWidget(title: 'Temp max', value: '${_weather?.main.tempMax.round()} \u00B0C'),
            ],
          ),
      
          // Spacer
          const SizedBox(height: 8),
      
          // Info collection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueWidget(title: 'Pressure', value: '${_weather?.main.pressure} mb'),
              const SizedBox(width: 8),
              ValueWidget(title: 'Wind', value: '${_weather?.wind.speed.round()} m/s'),
              const SizedBox(width: 8),
              ValueWidget(title: 'Feels like', value: '${_weather?.main.feelsLike.round()} \u00B0C'),
            ],
          ),
      
          // Spacer
          const Expanded(
            child: SizedBox(),
          ),
      
          // Copyright
          const Center(
            child: Text(
              'Created by Denis Kutlubaev',
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
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
    final cityName = ref.watch(cityNameProvider);
    final weatherAsyncValue = ref.watch(weatherProvider(cityName));

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              weatherAsyncValue.when(
                data: (weather) {
                  _weather = weather;
                  return _buildWeatherInfo();
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) {
                  return Text('Error: $error');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
