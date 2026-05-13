import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/solicitudes_service.dart';
import '../models/solicitud_model.dart';
import 'paso2b_preguntas_screen.dart';
import 'dart:typed_data';
import '../../../core/services/storage_service.dart';
import 'dart:convert';

class Paso2DescripcionScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  const Paso2DescripcionScreen({super.key, required this.solicitud});

  @override
  State<Paso2DescripcionScreen> createState() => _Paso2DescripcionScreenState();
}

class _Paso2DescripcionScreenState extends State<Paso2DescripcionScreen> {
  final TextEditingController _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _imagenesSeleccionadas = [];
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _descController.text = widget.solicitud.descripcion ?? '';
    _descController.addListener(() => setState(() {
          widget.solicitud.descripcion = _descController.text;
        }));
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(context);
                final foto = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                if (foto != null) setState(() => _imagenesSeleccionadas.add(File(foto.path)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Elegir de galería'),
              onTap: () async {
                Navigator.pop(context);
                final fotos = await _picker.pickMultiImage(imageQuality: 70);
                if (fotos.isNotEmpty) {
                  setState(() => _imagenesSeleccionadas.addAll(fotos.map((f) => File(f.path))));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarImagen(int index) {
    setState(() => _imagenesSeleccionadas.removeAt(index));
  }

  Future<void> _analizar() async {
  if (_imagenesSeleccionadas.isEmpty) {
    setState(() => _error = 'Debes adjuntar al menos una foto.');
    return;
  }

  setState(() { _cargando = true; _error = null; });
  try {
    // 1. Subir imágenes a Supabase Storage → obtener URLs
    final urls = await StorageService.subirImagenes(_imagenesSeleccionadas);
    widget.solicitud.imagenesUrls = urls;

    // 2. Convertir imágenes a base64 para que Groq las analice
    final imagenesBase64 = await Future.wait(
      _imagenesSeleccionadas.map((f) async {
        final bytes = await f.readAsBytes();
        return base64Encode(bytes);
      }),
    );

    // 3. Mandar al backend: URL para guardar en BD + base64 para Groq
    final analisis = await SolicitudesService.analizar(
      texto: widget.solicitud.descripcion,
      imagenUrl: urls.first,
      imagenesBase64: imagenesBase64,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Paso2bPreguntasScreen(
          solicitud: widget.solicitud,
          analisis: analisis,
        ),
      ),
    );
  } catch (e) {
    setState(() => _error = 'Error al analizar. Intenta de nuevo.');
  } finally {
    setState(() => _cargando = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final puedeContinar = _descController.text.trim().isNotEmpty && !_cargando;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text('Nueva solicitud',
                style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Paso 2 de 6',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 2 / 6,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cuéntanos el problema',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('Mientras más detalles des, mejor será la oferta.',
                      style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Ej. El interruptor de la sala no enciende la luz...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Área de fotos
                  GestureDetector(
                    onTap: _seleccionarImagen,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _imagenesSeleccionadas.isEmpty
                          ? const Column(
                              children: [
                                Icon(Icons.camera_alt, color: AppColors.textGrey, size: 40),
                                SizedBox(height: 12),
                                Text('Adjuntar fotos',
                                    style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                Text('Toca para agregar',
                                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _imagenesSeleccionadas.length + 1,
                                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                                      itemBuilder: (context, i) {
                                        if (i == _imagenesSeleccionadas.length) {
                                          // Botón agregar más
                                          return GestureDetector(
                                            onTap: _seleccionarImagen,
                                            child: Container(
                                              width: 90,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.grey[300]!),
                                              ),
                                              child: const Icon(Icons.add, color: AppColors.textGrey),
                                            ),
                                          );
                                        }
                                        return Stack(
                                          children: [
                                            FutureBuilder<Uint8List>(
                                              future: _imagenesSeleccionadas[i].readAsBytes(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) return const SizedBox(width: 90, height: 100);
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.memory(
                                                    snapshot.data!,
                                                    width: 90,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () => _eliminarImagen(i),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),

                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: puedeContinar ? _analizar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _cargando
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Continuar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}