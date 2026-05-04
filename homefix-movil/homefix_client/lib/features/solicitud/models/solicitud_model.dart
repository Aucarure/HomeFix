class SolicitudModel {
  String? categoria;
  String? descripcion;
  List<String> fotos;
  double? precioSugerido;
  double? precioFinal;
  String? direccion;
  bool conPrioridad;

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
