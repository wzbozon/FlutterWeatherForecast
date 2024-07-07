import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../models/city_model.dart';

part 'cities_provider.g.dart';

@riverpod
final databaseProvider = Provider<Future<Database>>((ref) async {
  return openDatabase(
    path.join(await getDatabasesPath(), 'cities_database.db'),
    version: 1,
  );
});

@riverpod
Future<List<String>> cities(ref) async {
    final database = ref.watch(databaseProvider);
    final db = await database;
    final cityMaps = await db.query('cities');
    return cityMaps.map((cityMap) => City.fromMap(cityMap)).toList();
}
