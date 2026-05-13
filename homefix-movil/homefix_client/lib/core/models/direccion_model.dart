class DireccionModel {
  final String id;
  final String usuarioId;
  final String? etiqueta;
  final String? distrito;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final bool esPredeterminada;

  DireccionModel({
    required this.id,
    required this.usuarioId,
    this.etiqueta,
    this.distrito,
    this.direccion,
    this.latitud,
    this.longitud,
    this.esPredeterminada = false,
  });

  factory DireccionModel.fromJson(Map<String, dynamic> json) {
    return DireccionModel(
      id: json['id'],
      usuarioId: json['usuario_id'],
      etiqueta: json['etiqueta'],
      distrito: json['distrito'],
      direccion: json['direccion'],
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      esPredeterminada: json['es_predeterminada'] ?? false,
    );
  }
}