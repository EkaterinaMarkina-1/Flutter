import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';
import 'package:cofe_fest/src/features/menu/map/cluster_icon_painter.dart';
import 'package:cofe_fest/src/features/menu/map/location_repository.dart';
import 'package:cofe_fest/src/features/menu/map/location_bottom_sheet.dart';
import 'package:cofe_fest/src/features/menu/map/location_list_screen.dart';
import 'package:location/location.dart' as loc;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final YandexMapController _mapController;
  Location? selectedLocation;
  late loc.Location location;

  @override
  void initState() {
    super.initState();
    location = loc.Location();
  }

  Future<void> _getUserLocation() async {
    try {
      final permissionStatus = await location.requestPermission();
      if (permissionStatus == loc.PermissionStatus.granted) {
        final userLocation = await location.getLocation();
        if (userLocation.latitude != null && userLocation.longitude != null) {
          await _mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: Point(
                  latitude: userLocation.latitude!,
                  longitude: userLocation.longitude!,
                ),
                zoom: 12,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Местоположение пользователя недоступно')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Доступ к геолокации запрещён')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Не удалось получить геолокацию пользователя')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Расширяем тело экрана за пределы AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Устанавливаем прозрачный AppBar
        elevation: 0, // Убираем тень у AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Возврат к предыдущему экрану
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/map.png',
              width: 35, // Укажите желаемый размер
              height: 35,
            ),
            onPressed: () async {
              // Навигация на экран с адресами
              final selectedLocation = await Navigator.push<Location>(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationListScreen(),
                ),
              );

              if (selectedLocation != null) {
                // Если выбрали локацию, обновляем отображение
                setState(() {
                  this.selectedLocation = selectedLocation;
                });

                // Перемещаем камеру на выбранную локацию
                await _mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: selectedLocation.lat,
                        longitude: selectedLocation.lng,
                      ),
                      zoom: 12,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Location>>(
        future:
            LocationRepository().fetchLocations(), // Получаем список локаций
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Отображаем индикатор загрузки
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

                  // Получаем текущую геолокацию пользователя при создании карты
                  await _getUserLocation();

                  // Если геолокация недоступна, центрируем карту на первой локации из списка
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
                    locations:
                        locations, // Передаём список локаций для кластеризации
                  ),
                ],
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
            onTap: (_, __) =>
                _onPlacemarkTapped(location), // Обработка нажатия на маркер
          ),
        )
        .toList();

    return ClusterizedPlacemarkCollection(
      mapId: const MapObjectId('clusterized-1'),
      placemarks: placemarks,
      radius: 50, // Радиус для объединения маркеров в кластер
      minZoom: 15, // Минимальный зум для кластеризации
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
  void _onPlacemarkTapped(Location location) async {
    // Перемещаем камеру на координаты выбранного маркера
    await _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: location.lat, longitude: location.lng),
          zoom: 15, // Можно установить нужный уровень зума
        ),
      ),
    );

    // Показываем BottomSheet с информацией о локации
    showModalBottomSheet(
      context: context,
      builder: (context) => LocationBottomSheet(
        location: location,
        onSelect: () {
          setState(() {
            selectedLocation = location;
          });
          Navigator.pop(context); // Закрытие BottomSheet
          Navigator.pop(context, location); // Возвращаем выбранную локацию
        },
      ),
    );
  }
}
