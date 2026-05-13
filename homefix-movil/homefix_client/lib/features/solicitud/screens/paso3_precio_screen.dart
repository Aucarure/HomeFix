import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/solicitud_model.dart';
import 'paso4_ubicacion_screen.dart';

class Paso3PrecioScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  const Paso3PrecioScreen({super.key, required this.solicitud});

  @override
  State<Paso3PrecioScreen> createState() => _Paso3PrecioScreenState();
}

class _Paso3PrecioScreenState extends State<Paso3PrecioScreen> {
  late TextEditingController _precioController;
  String? _advertencia;

  double get _min => widget.solicitud.precioMinimo ?? 0;
  double get _max => widget.solicitud.precioMaximo ?? 9999;

  @override
  void initState() {
    super.initState();
    final inicial = widget.solicitud.precioSugerido ?? _min;
    _precioController = TextEditingController(text: inicial.toStringAsFixed(0));
    widget.solicitud.precioFinal = inicial;
  }

  @override
  void dispose() {
    _precioController.dispose();
    super.dispose();
  }

  void _onPrecioChanged(String val) {
    final precio = double.tryParse(val);
    if (precio == null) return;
    widget.solicitud.precioFinal = precio;
    if (precio < _min || precio > _max) {
      setState(() => _advertencia =
          'El precio debe estar entre S/. ${_min.toStringAsFixed(0)} y S/. ${_max.toStringAsFixed(0)}');
    } else {
      setState(() => _advertencia = null);
    }
  }

  bool get _puedeContinar {
    final precio = double.tryParse(_precioController.text);
    return precio != null && precio >= _min && precio <= _max;
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
            Text('Paso 3 de 6',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 3 / 6,
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
                  Row(
                    children: const [
                      Icon(Icons.auto_fix_high, color: AppColors.primary, size: 16),
                      SizedBox(width: 8),
                      Text('IA ANALIZÓ TU SOLICITUD',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold,
                              fontSize: 12, letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Precio referencial sugerido',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 32),
                  // Card precio sugerido
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('Precio sugerido', style: TextStyle(color: AppColors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          'S/. ${widget.solicitud.precioSugerido?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rango: S/. ${_min.toStringAsFixed(0)} – S/. ${_max.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.white, fontSize: 13),
                        ),
                        if (widget.solicitud.justificacion != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            widget.solicitud.justificacion!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.white.withOpacity(0.85), fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Puedes modificarlo libremente',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Text(
                    'Dentro del rango S/. ${_min.toStringAsFixed(0)} – S/. ${_max.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    onChanged: _onPrecioChanged,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    decoration: InputDecoration(
                      prefixText: 'S/. ',
                      prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: _advertencia != null ? Colors.red : Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: _advertencia != null ? Colors.red : Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: _advertencia != null ? Colors.red : AppColors.primary),
                      ),
                    ),
                  ),
                  if (_advertencia != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                          const SizedBox(width: 6),
                          Text(_advertencia!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                        ],
                      ),
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
                onPressed: _puedeContinar
                    ? () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => Paso4UbicacionScreen(solicitud: widget.solicitud),
                        ))
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}