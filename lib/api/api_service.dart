import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://coffeeshop.academy.effective.band';

  static Future<http.Response> placeOrder(
      {required Map<String, int> positions}) async {
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
