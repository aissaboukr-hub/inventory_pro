import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSheetsService {
  static const String url = "https://script.google.com/macros/s/AKfycbxd6wkoYWXyOgdqAaaheaYZEM-hZrVFPKKfeUSQAsjZnLNQvRi6kWjvNnr7s9fCP44/exec";

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
