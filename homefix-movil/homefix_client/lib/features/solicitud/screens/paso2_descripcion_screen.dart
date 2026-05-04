import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/solicitud_model.dart';
import 'paso3_precio_screen.dart';

class Paso2DescripcionScreen extends StatefulWidget {
  final SolicitudModel solicitud;

  const Paso2DescripcionScreen({super.key, required this.solicitud});

  @override
  State<Paso2DescripcionScreen> createState() => _Paso2DescripcionScreenState();
}

class _Paso2DescripcionScreenState extends State<Paso2DescripcionScreen> {
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descController.text = widget.solicitud.descripcion ?? '';
    _descController.addListener(() {
      setState(() {
        widget.solicitud.descripcion = _descController.text;
      });
    });
  }

  @override
  void dispose() {
    _descController.dispose();
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
              'Paso 2 de 6',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
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
                  const Text(
                    'Cuéntanos el problema',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mientras más detalles des, mejor será la oferta.',
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Ej. El interruptor de la sala no enciende la luz del techo...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Área punteada para fotos simulada
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        style: BorderStyle.solid, 
                      ),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.camera_alt, color: AppColors.textGrey, size: 40),
                        SizedBox(height: 12),
                        Text('Adjuntar fotos', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500)),
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
                onPressed: _descController.text.trim().isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Paso3PrecioScreen(solicitud: widget.solicitud),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
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
