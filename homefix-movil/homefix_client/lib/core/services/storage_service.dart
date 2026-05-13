import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final _supabase = Supabase.instance.client;

  static Future<List<String>> subirImagenes(List<File> imagenes) async {
    final List<String> urls = [];

    for (final imagen in imagenes) {
      final extension = imagen.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$extension';
      final path = 'solicitudes/$fileName';

      await _supabase.storage
          .from('solicitud-imagenes')
          .upload(path, imagen);

      final url = _supabase.storage
          .from('solicitud-imagenes')
          .getPublicUrl(path);

      urls.add(url);
    }

    return urls;
  }
}