import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as myPath;

import '../models/city_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cities_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = myPath.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cities(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL, 
      latitude REAL, 
      longitude REAL
      )
      ''');

    await _addDefaultCitiesToDatabase(db);
  }

  Future<List<City>> getCities() async {
    final db = await instance.database;
    final result = await db.query('cities');
    return result.map((json) => City.fromMap(json)).toList();
  }

  Future<void> _clearDatabase(Database db) async {
    await db.execute('DROP TABLE IF EXISTS cities');
  }

  Future<void> _addDefaultCitiesToDatabase(Database db) async {
    String citiesJsonFile = "default_cities.json";
    String citiesJsonString = await rootBundle.loadString('assets/json/$citiesJsonFile');
    Map<String, dynamic> citiesDict = jsonDecode(citiesJsonString);
    List<dynamic> citiesJson = citiesDict["cities"];
    for (var cityJson in citiesJson) {
      City city = City.fromMap(cityJson);
      await db.insert(
        'cities',
        city.toMap(),
      );
    }
  }
}
