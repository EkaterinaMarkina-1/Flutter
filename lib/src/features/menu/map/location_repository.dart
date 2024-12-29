import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cofe_fest/src/features/menu/map/location.dart';

class LocationRepository {
  static const String baseUrl = 'https://coffeeshop.academy.effective.band';

  Future<List<Location>> fetchLocations() async {
    final url = Uri.parse('$baseUrl/api/v1/locations');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(responseData);

      if (jsonResponse is Map && jsonResponse.containsKey('data')) {
        final locations = jsonResponse['data'];
        return locations
            .map<Location>((json) => Location.fromJson(json))
            .toList();
      } else {
        throw Exception('Ошибка: неверный формат данных');
      }
    } else {
      throw Exception('Ошибка загрузки локаций');
    }
  }
}
