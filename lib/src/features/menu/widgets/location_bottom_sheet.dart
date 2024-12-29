import 'package:flutter/material.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';

class LocationBottomSheet extends StatelessWidget {
  final Location location;
  final VoidCallback onSelect;

  const LocationBottomSheet({
    super.key,
    required this.location,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            location.address,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: onSelect,
            child: const Text('Выбрать'),
          ),
        ],
      ),
    );
  }
}
