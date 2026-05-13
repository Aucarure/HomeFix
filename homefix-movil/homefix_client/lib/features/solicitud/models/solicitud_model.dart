class SolicitudModel {
  String? categoria;
  String? descripcion;
  List<String> fotos;
  double? precioSugerido;
  double? precioFinal;
  String? direccion;
  bool conPrioridad;

  // Del backend
  String? imagenUrl;
  List<String> imagenesUrls = [];
  String? textoMejorado;
  String? problemaDetectado;
  String? categoriaDetectada;
  double? precioMinimo;
  double? precioMaximo;
  String? nivelUrgencia;
  String? justificacion;
  String? observaciones;

  // Ubicación
  String? direccionId;
  double? latitud;
  double? longitud;

  // ID de la solicitud creada en backend
  String? solicitudId;

  SolicitudModel({
    this.categoria,
    this.descripcion,
    this.fotos = const [],
    this.precioSugerido,
    this.precioFinal,
    this.direccion,
    this.conPrioridad = false,
  });
}