import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location.dart';

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
        if (locations is List) {
          return locations
              .map<Location>((json) => Location.fromJson(json))
              .toList();
        } else {
          throw Exception('Ошибка: "data" не является списком');
        }
      } else {
        throw Exception(
            'Ошибка: Отсутствует ключ "data" или структура неправильная');
      }
    } else {
      throw Exception('Ошибка загрузки локаций');
    }
  }
}
