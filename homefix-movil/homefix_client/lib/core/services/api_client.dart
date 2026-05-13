import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // 🔧 Cambia por tu IP local en desarrollo
  // Para emulador Android: 10.0.2.2
  // Para dispositivo físico: IP de tu PC en la red local
//PARA USARLO EN EMULADOR
static const String baseUrl = 'http://10.0.2.2:3000/api';
// PARA USARLO EN WEB
//static const String baseUrl = 'http://localhost:3000/api';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  static Future<List<dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}