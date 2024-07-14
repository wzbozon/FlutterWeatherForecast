import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/city_model.dart';
import '../providers/database_provider.dart';

final citiesProvider = FutureProvider.autoDispose<List<City>>((ref) async {
  final databaseHelper = ref.watch(databaseProvider);
  final db = await databaseHelper.database;
  final cityMaps = await db.query('cities');
  return cityMaps.map((cityMap) => City.fromMap(cityMap)).toList();
});