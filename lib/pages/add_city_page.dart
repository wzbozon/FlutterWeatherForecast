import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/city_model.dart';

class AddCityPage extends StatefulWidget {
  const AddCityPage({super.key});

  @override
  State<AddCityPage> createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {
  late TextEditingController _nameController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _addCityToDatabase(City city) async {
    final database = openDatabase(
      path.join(await getDatabasesPath(), 'cities_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cities(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)',
        );
      },
      version: 1,
    );

    final db = await database;
    await db.insert(
      'cities',
      city.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void _addCity() {
    final name = _nameController.text;
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);

    if (name.isNotEmpty && latitude != null && longitude != null) {
      final city = City(name: name, latitude: latitude, longitude: longitude);
      _addCityToDatabase(city);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add City'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'City Name'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addCity,
              child: Text('Add City'),
            ),
          ],
        ),
      ),
    );
  }
}
