import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/services/api_client.dart';

class AuthService {
  // LOGIN
  static Future<Map<String, dynamic>> login(String correo, String password) async {
    return await ApiClient.post('/auth/login', {
      'correo': correo,
      'password': password,
    });
  }

  // REGISTRO CLIENTE
  static Future<Map<String, dynamic>> registrarCliente({
    required String nombreCompleto,
    required String correo,
    required String telefono,
    required String password,
  }) async {
    return await ApiClient.post('/auth/registro/cliente', {
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'telefono': telefono,
      'password': password,
    });
  }

  // REGISTRO TÉCNICO (con archivos - usa multipart)
  static Future<Map<String, dynamic>> registrarTecnico({
    required String nombreCompleto,
    required String correo,
    required String telefono,
    required String password,
    required List<File> certificados,
  }) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/auth/registro/tecnico');
    final request = http.MultipartRequest('POST', uri);

    request.fields['nombre_completo'] = nombreCompleto;
    request.fields['correo'] = correo;
    request.fields['telefono'] = telefono;
    request.fields['password'] = password;

    for (final archivo in certificados) {
      final nombreArchivo = archivo.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'certificados',
        archivo.path,
        filename: nombreArchivo,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al registrar técnico');
    }
  }
}