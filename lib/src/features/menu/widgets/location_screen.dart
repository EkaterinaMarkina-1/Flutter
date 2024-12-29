import 'package:flutter/material.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';

class LocationScreen extends StatelessWidget {
  final List<Location> locations;
  final String currentAddress;

  const LocationScreen({
    super.key,
    required this.locations,
    required this.currentAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Выбор адреса"),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return ListTile(
            title: Text(location.address),
            trailing: currentAddress == location.address
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              Navigator.pop(context, location);
            },
          );
        },
      ),
    );
  }
}
