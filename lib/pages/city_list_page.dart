import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/pages/add_city_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/city_model.dart';
import '../pages/add_city_page.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({super.key});

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  List<City> cities = [];

  @override
  void initState() {
    super.initState();
    _fetchCitiesFromDatabase();
  }

  Future<void> _fetchCitiesFromDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'cities_database.db'),
      version: 1,
    );
    final db = await database;
    final cityMaps = await db.query('cities');
    setState(() {
      cities = cityMaps.map((cityMap) => City.fromMap(cityMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCityPage()),
              ).then((_) {
                _fetchCitiesFromDatabase();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            title: Text(city.name),
            subtitle: Text('Latitude: ${city.latitude}, Longitude: ${city.longitude}'),
          );
        },
      ),
    );
  }
}
