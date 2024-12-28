import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';
import 'package:cofe_fest/src/features/menu/map/cluster_icon_painter.dart';
import 'package:cofe_fest/src/features/menu/map/location_repository.dart';
import 'package:cofe_fest/src/features/menu/map/location_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final YandexMapController _mapController;
  Location? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Расширяем тело за AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Функция назад
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.black),
            onPressed: () =>
                _showLocationListBottomSheet(context), // Показ списка адресов
          ),
        ],
      ),
      body: FutureBuilder<List<Location>>(
        future: LocationRepository().fetchLocations(), // Получение локаций
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Не удалось загрузить данные.'));
          }

          final locations = snapshot.data!;
          return Stack(
            children: [
              YandexMap(
                onMapCreated: (controller) async {
                  _mapController = controller;
                  if (locations.isNotEmpty) {
                    await _mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: locations.first.lat,
                            longitude: locations.first.lng,
                          ),
                          zoom: 12,
                        ),
                      ),
                    );
                  }
                },
                mapObjects: [
                  _getClusterizedCollection(
                    locations: locations,
                  ),
                ],
              ),
              if (selectedLocation != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Text(
                      'Выбранный адрес: ${selectedLocation!.address}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Метод для получения кластеризованных маркеров
  ClusterizedPlacemarkCollection _getClusterizedCollection({
    required List<Location> locations,
  }) {
    final placemarks = locations
        .map(
          (location) => PlacemarkMapObject(
            mapId: MapObjectId(location.address),
            point: Point(latitude: location.lat, longitude: location.lng),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/icon/map_point.png',
                ),
                scale: 1.5,
              ),
            ),
            onTap: (_, __) => _onPlacemarkTapped(location),
          ),
        )
        .toList();

    return ClusterizedPlacemarkCollection(
      mapId: const MapObjectId('clusterized-1'),
      placemarks: placemarks,
      radius: 50,
      minZoom: 15,
      onClusterAdded: (self, cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await ClusterIconPainter(cluster.size).getClusterIconBytes(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Метод для отображения BottomSheet с информацией о локации
  void _onPlacemarkTapped(Location location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => LocationBottomSheet(
        location: location,
        onSelect: () {
          setState(() {
            selectedLocation = location;
          });
          Navigator.pop(context); // Закрытие BottomSheet
        },
      ),
    );
  }

  // Метод для отображения BottomSheet со списком всех адресов
  void _showLocationListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Полноэкранный BottomSheet
      builder: (context) {
        return FutureBuilder<List<Location>>(
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
              shrinkWrap: true,
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return ListTile(
                  title: Text(location.address),
                  onTap: () async {
                    // Сохраняем выбранный адрес
                    setState(() {
                      selectedLocation = location;
                    });

                    // Получаем текущую позицию камеры, чтобы использовать её зум
                    final currentCameraPosition =
                        await _mapController.getCameraPosition();

                    // Перемещаем карту на выбранную локацию без изменения масштаба
                    await _mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: location.lat,
                            longitude: location.lng,
                          ),
                          zoom: currentCameraPosition.zoom,
                        ),
                      ),
                    );

                    Navigator.pop(context); // Закрываем BottomSheet

                    // Возвращаемся на главный экран
                    Navigator.pop(
                        context, location); // Передаем выбранный адрес
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
