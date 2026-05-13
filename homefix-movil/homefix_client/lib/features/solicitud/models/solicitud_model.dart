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