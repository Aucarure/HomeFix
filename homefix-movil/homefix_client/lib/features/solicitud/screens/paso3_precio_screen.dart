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
  final TextEditingController _precioController = TextEditingController(text: '80');

  @override
  void initState() {
    super.initState();
    if (widget.solicitud.precioSugerido == null) {
      widget.solicitud.precioSugerido = 80.0;
      widget.solicitud.precioFinal = 80.0;
    } else {
      _precioController.text = widget.solicitud.precioFinal.toString();
    }
  }

  @override
  void dispose() {
    _precioController.dispose();
    super.dispose();
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
          children: [
            const Text(
              'Nueva solicitud',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'Paso 3 de 6',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
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
                      Text(
                        'IA ANALIZÓ TU SOLICITUD',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Precio referencial sugerido',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text('Precio sugerido', style: TextStyle(color: AppColors.white, fontSize: 14)),
                        SizedBox(height: 8),
                        Text('S/. 80', style: TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        Text('Basado en tu descripción y fotos', style: TextStyle(color: AppColors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Puedes modificarlo libremente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    decoration: InputDecoration(
                      prefixText: 'S/. ',
                      prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      widget.solicitud.precioFinal = double.tryParse(val) ?? 80.0;
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Paso4UbicacionScreen(solicitud: widget.solicitud),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
