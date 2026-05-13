import '../models/analisis_response.dart';
import '../models/confirmacion_response.dart';
import 'api_client.dart';

class SolicitudesService {
  // PASO 1 — Analiza texto/imagen, devuelve preguntas
 static Future<AnalisisResponse> analizar({
  String? texto,
  String? imagenUrl,
  List<String>? imagenesBase64,
}) async {
  final body = <String, dynamic>{};
  if (texto != null) body['texto'] = texto;
  if (imagenUrl != null) body['imagen_url'] = imagenUrl;
  if (imagenesBase64 != null && imagenesBase64.isNotEmpty) {
    body['imagenes_base64'] = imagenesBase64;
  }

  final data = await ApiClient.post('/solicitudes/analizar', body);
  return AnalisisResponse.fromJson(data);
}

  // PASO 2 — Confirma con respuestas, obtiene precio estimado
  static Future<ConfirmacionResponse> confirmar({
    required String usuarioId,
    required String problemaDetectado,
    required String categoria,
    required String textMejorado,
    required List<Map<String, String>> preguntasRespuestas,
    String? imagenUrl,
    String? categoriaId,
    String? direccionId,
  }) async {
    final body = {
      'usuario_id': usuarioId,
      'problema_detectado': problemaDetectado,
      'categoria': categoria,
      'texto_mejorado': textMejorado,
      'preguntas_respuestas': preguntasRespuestas,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (direccionId != null) 'direccion_id': direccionId,
    };

    final data = await ApiClient.post('/solicitudes/confirmar', body);
    return ConfirmacionResponse.fromJson(data);
  }
}