import 'api_client.dart';

class Oferta {
  final String id;
  final double precioOfertado;
  final double? precioNegociado;
  final String mensaje;
  final String estado;
  final String usuarioId;
  final String nombreTecnico;
  final String? fotoPerfil;
  final double? latitud;
  final double? longitud;

  Oferta({
    required this.id,
    required this.precioOfertado,
    this.precioNegociado,
    required this.mensaje,
    required this.estado,
    required this.usuarioId,
    required this.nombreTecnico,
    this.fotoPerfil,
    this.latitud,
    this.longitud,
  });

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: json['id'],
      precioOfertado: (json['precio_ofertado'] as num).toDouble(),
      precioNegociado: json['precio_negociado'] != null
          ? (json['precio_negociado'] as num).toDouble()
          : null,
      mensaje: json['mensaje'],
      estado: json['estado'],
      usuarioId: json['usuario_id'],
      nombreTecnico: json['usuarios']['nombre_completo'],
      fotoPerfil: json['usuarios']['foto_perfil_url'],
      latitud: json['ubicacion']?['latitud']?.toDouble(),
      longitud: json['ubicacion']?['longitud']?.toDouble(),
    );
  }
}

class OfertasService {
  static Future<List<Oferta>> getOfertas(String solicitudId) async {
    final data = await ApiClient.getList('/ofertas/$solicitudId');
    return data.map((o) => Oferta.fromJson(o)).toList();
  }

  static Future<void> negociar(String ofertaId, double precio) async {
    await ApiClient.post('/ofertas/$ofertaId/negociar', {
      'precio_negociado': precio,
    });
  }

  static Future<Map<String, dynamic>> getEstado(String ofertaId) async {
    return await ApiClient.getMap('/ofertas/$ofertaId/estado');
  }
}