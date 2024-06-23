import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/pages/add_city_page.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/city_model.dart';

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

    Future.delayed(Duration.zero, () async {
      // await _clearDatabase();
      await _addDefaultCitiesToDatabase(context);
      await _fetchCitiesFromDatabase();
    });
  }

  Future<void> _clearDatabase() async {
    final database = openDatabase(
      path.join(await getDatabasesPath(), 'cities_database.db'),
      version: 1,
    );
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS cities');
  }

  Future<void> _addDefaultCitiesToDatabase(BuildContext context) async {
    final database = openDatabase(
      path.join(await getDatabasesPath(), 'cities_database.db'),
      version: 1,
    );
    final db = await database;
    await db.execute(
      'CREATE TABLE IF NOT EXISTS cities(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, latitude REAL, longitude REAL)',
    );
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cities'));
    if (count == 0) {
      AssetBundle rootBundle = DefaultAssetBundle.of(context);
      String citiesJsonFile = "default_cities.json";
      String citiesJsonString = await rootBundle.loadString('assets/json/$citiesJsonFile');
      Map<String, dynamic> citiesDict = jsonDecode(citiesJsonString);
      List<dynamic> citiesJson = citiesDict["cities"];
      for (var cityJson in citiesJson) {
        await db.insert(
          'cities',
          City(
            name: cityJson['name'],
            latitude: cityJson['latitude'],
            longitude: cityJson['longitude'],
          ).toMap(),
        );
      }
    }
  }

  Future<void> _fetchCitiesFromDatabase() async {
    final database = openDatabase(
      path.join(await getDatabasesPath(), 'cities_database.db'),
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
        title: const Text('Select City'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCityPage()),
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
            onTap: () {
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }
}
