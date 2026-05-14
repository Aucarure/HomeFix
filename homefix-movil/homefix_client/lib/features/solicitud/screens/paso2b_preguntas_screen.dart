import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/analisis_response.dart';
import '../../../core/services/solicitudes_service.dart';
import '../models/solicitud_model.dart';
import 'paso3_precio_screen.dart';
import '../../../core/services/session_service.dart';

class Paso2bPreguntasScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  final AnalisisResponse analisis;

  const Paso2bPreguntasScreen({super.key, required this.solicitud, required this.analisis});

  @override
  State<Paso2bPreguntasScreen> createState() => _Paso2bPreguntasScreenState();
}

class _Paso2bPreguntasScreenState extends State<Paso2bPreguntasScreen> {
  late List<TextEditingController> _controllers;
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.analisis.preguntas.length, (_) => TextEditingController());
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  bool get _todasRespondidas => _controllers.every((c) => c.text.trim().isNotEmpty);

  Future<void> _confirmar() async {
    setState(() { _cargando = true; _error = null; });
    try {
      final preguntasRespuestas = List.generate(
        widget.analisis.preguntas.length,
        (i) => {
          'pregunta': widget.analisis.preguntas[i].pregunta,
          'respuesta': _controllers[i].text.trim(),
        },
      );

      final resultado = await SolicitudesService.confirmar(
        usuarioId: SessionService.usuarioId ?? '', 
        problemaDetectado: widget.analisis.problemaDetectado,
        categoria: widget.analisis.categoria,
        textMejorado: widget.analisis.textoMejorado ?? widget.solicitud.descripcion ?? '',
        preguntasRespuestas: preguntasRespuestas,
        imagenUrl: widget.solicitud.imagenUrl,
      );

      widget.solicitud
        ..textoMejorado = widget.analisis.textoMejorado
        ..problemaDetectado = widget.analisis.problemaDetectado
        ..categoriaDetectada = widget.analisis.categoria
        ..precioMinimo = resultado.ia.precioMinimo.toDouble()
        ..precioMaximo = resultado.ia.precioMaximo.toDouble()
        ..precioSugerido = resultado.ia.precioMinimo.toDouble()
        ..precioFinal = resultado.ia.precioMinimo.toDouble()
        ..nivelUrgencia = resultado.ia.nivelUrgencia
        ..justificacion = resultado.ia.justificacion
        ..observaciones = resultado.ia.observaciones;

       if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => Paso3PrecioScreen(solicitud: widget.solicitud),
      ));
    } catch (e) {
      print('❌ ERROR CONFIRMAR: $e'); // ← AGREGA ESTA LÍNEA
      setState(() => _error = 'Error al obtener estimación. Intenta de nuevo.');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_fix_high, color: AppColors.primary, size: 14),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.analisis.textoMejorado != null && widget.analisis.imagenUrl != null
                                ? 'IA analizó texto e imagen correctamente'
                                : widget.analisis.textoMejorado != null
                                    ? 'IA analizó el texto correctamente'
                                    : 'IA analizó la imagen correctamente',
                            style: const TextStyle(color: AppColors.primary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Ayúdanos a entender mejor',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  const Text('Responde para obtener un precio más preciso.',
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                  const SizedBox(height: 28),
                  ...List.generate(widget.analisis.preguntas.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${i + 1}. ${widget.analisis.preguntas[i].pregunta}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controllers[i],
                            decoration: InputDecoration(
                              hintText: 'Tu respuesta...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: AppColors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
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
                onPressed: (_todasRespondidas && !_cargando) ? _confirmar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _cargando
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Obtener precio estimado',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}