import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../providers/weather_provider.dart';

class CityNameNotifier extends StateNotifier<String> {
  final WeatherService _weatherService;

  CityNameNotifier(this._weatherService) : super('') {
    _initialize();
  }

  Future<void> _initialize() async {
    final currentCity = await _weatherService.getCurrentCity();
    state = currentCity;
  }

  void updateCityName(String newCityName) {
    state = newCityName;
  }
}

final cityNameProvider = StateNotifierProvider<CityNameNotifier, String>((ref) {
  final weatherService = ref.watch(weatherServiceProvider);
  return CityNameNotifier(weatherService);
});
