class EstimacionIA {
  final int precioMinimo;
  final int precioMaximo;
  final String moneda;
  final String nivelUrgencia;
  final String justificacion;
  final String observaciones;

  EstimacionIA({
    required this.precioMinimo,
    required this.precioMaximo,
    required this.moneda,
    required this.nivelUrgencia,
    required this.justificacion,
    required this.observaciones,
  });

  factory EstimacionIA.fromJson(Map<String, dynamic> json) {
    return EstimacionIA(
      precioMinimo: json['precio_minimo'],
      precioMaximo: json['precio_maximo'],
      moneda: json['moneda'],
      nivelUrgencia: json['nivel_urgencia'],
      justificacion: json['justificacion'],
      observaciones: json['observaciones'],
    );
  }
}

class ConfirmacionResponse {
  final Map<String, dynamic> solicitud;
  final EstimacionIA ia;

  ConfirmacionResponse({required this.solicitud, required this.ia});

  factory ConfirmacionResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmacionResponse(
      solicitud: json['solicitud'],
      ia: EstimacionIA.fromJson(json['ia']),
    );
  }
}