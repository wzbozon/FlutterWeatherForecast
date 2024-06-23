import 'package:intl/intl.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int date;

  String humanReadableDate() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    DateFormat formatter = DateFormat('EEE, d MMM yyyy, hh:mm a');
    return formatter.format(dateTime);
  }

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      date: json['dt'].toInt(),
    );
  }
}
