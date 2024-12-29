import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';

import 'package:cofe_fest/src/features/menu/data/data_sources/menu_data_source.dart';
import 'package:cofe_fest/src/features/menu/map/location.dart';

class ApiService implements IMenuDataSource {
  static const String baseUrl = 'https://coffeeshop.academy.effective.band';

  @override
  Future<List<MenuCategoryDto>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/api/v1/products/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(responseData);

      if (jsonResponse is Map && jsonResponse.containsKey('data')) {
        final categories = jsonResponse['data'];
        if (categories is List) {
          return categories
              .map<MenuCategoryDto>((json) => MenuCategoryDto.fromJson(json))
              .toList();
        } else {
          throw Exception('Ошибка: "data" не является списком');
        }
      } else {
        throw Exception(
            'Ошибка: Отсутствует ключ "data" или структура неправильная');
      }
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  @override
  Future<List<dynamic>> fetchProducts({
    required String category,
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/products?category_id=$category&page=$page&limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(responseData);

      if (jsonResponse is Map && jsonResponse.containsKey('data')) {
        final products = jsonResponse['data'];
        if (products is List) {
          return products;
        } else {
          throw Exception('Ошибка: "data" не является списком');
        }
      } else {
        throw Exception(
            'Ошибка: Отсутствует ключ "data" или структура неправильная');
      }
    } else {
      throw Exception('Ошибка загрузки товаров');
    }
  }

  static Future<http.Response> placeOrder({
    required Map<String, int> positions,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/orders');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'positions': positions,
          'token': '<FCM Registration Token>',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

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
