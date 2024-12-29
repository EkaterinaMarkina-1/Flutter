import 'package:flutter/material.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';
import 'package:cofe_fest/src/features/menu/map/location_repository.dart';

class LocationListScreen extends StatelessWidget {
  const LocationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Наши кофейни'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Location>>(
        future: LocationRepository().fetchLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Не удалось загрузить данные.'));
          }

          final locations = snapshot.data!;
          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                title: Text(location.address),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context, location);
                },
              );
            },
          );
        },
      ),
    );
  }
}
