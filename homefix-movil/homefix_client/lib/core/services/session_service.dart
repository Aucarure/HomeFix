class SessionService {
  static String? usuarioId;
  static String? nombre;
  static String? rol;

  static void guardar(Map<String, dynamic> usuario) {
    usuarioId = usuario['id']?.toString();
    nombre = usuario['nombre_completo']?.toString();
    rol = usuario['rol']?.toString();
  }

  static void cerrar() {
    usuarioId = null;
    nombre = null;
    rol = null;
  }
}