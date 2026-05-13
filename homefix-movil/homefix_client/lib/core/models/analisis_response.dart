class Pregunta {
  final int id;
  final String pregunta;
  Pregunta({required this.id, required this.pregunta});
  factory Pregunta.fromJson(Map<String, dynamic> json) =>
      Pregunta(id: json['id'], pregunta: json['pregunta']);
}

class AnalisisResponse {
  final String? textoMejorado;
  final String? imagenUrl;
  final String problemaDetectado;
  final String categoria;
  final List<Pregunta> preguntas;

  AnalisisResponse({
    this.textoMejorado,
    this.imagenUrl,
    required this.problemaDetectado,
    required this.categoria,
    required this.preguntas,
  });

  factory AnalisisResponse.fromJson(Map<String, dynamic> json) {
    return AnalisisResponse(
      textoMejorado: json['texto_mejorado'],
      imagenUrl: json['imagen_url'],
      problemaDetectado: json['problema_detectado'],
      categoria: json['categoria'],
      preguntas: (json['preguntas'] as List)
          .map((p) => Pregunta.fromJson(p))
          .toList(),
    );
  }
}