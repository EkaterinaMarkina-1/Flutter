import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';

class ApiService {
  static const String baseUrl = 'https://coffeeshop.academy.effective.band';

  static Future<List<MenuCategoryDto>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/api/v1/products/categories');
    try {
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
    } catch (e) {
      throw Exception('Ошибка получения категорий: $e');
    }
  }

  static Future<List<dynamic>> fetchProducts({
    required String category,
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/v1/products?category_id=$category&page=$page&limit=$limit');
    try {
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
    } catch (e) {
      throw Exception('Ошибка получения товаров: $e');
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
}
