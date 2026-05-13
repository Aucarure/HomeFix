import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/direccion_model.dart';

class DireccionesService {
  static final _supabase = Supabase.instance.client;

  // Trae todas las direcciones de un usuario
  static Future<List<DireccionModel>> getDirecciones(String usuarioId) async {
    final data = await _supabase
        .from('direcciones_usuario')
        .select()
        .eq('usuario_id', usuarioId)
        .order('es_predeterminada', ascending: false);

    return (data as List).map((d) => DireccionModel.fromJson(d)).toList();
  }
}