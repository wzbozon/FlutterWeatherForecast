import 'package:flutter/material.dart';
import 'package:weather_now/pages/add_city_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_now/providers/cities_provider.dart';

import '../models/city_model.dart';

class CityListPage extends ConsumerStatefulWidget {
  const CityListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CityListPageState();
}

class _CityListPageState extends ConsumerState<CityListPage> {
  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(citiesProvider);

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
              );
            },
          ),
        ],
      ),
      body: cities.when(
        data: (citiesList) => ListView.builder(
          itemCount: citiesList.length,
          itemBuilder: (context, index) {
            final city = citiesList[index];
            return buildCityCard(city, context);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildCityCard(City city, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Remove round corners
        ),
        color: Colors.white,
        child: ListTile(
          title: Text(city.name),
          subtitle: Text('Latitude: ${city.latitude}, Longitude: ${city.longitude}'),
          onTap: () {
            Navigator.pop(context, city);
          },
        ),
      ),
    );
  }
}
