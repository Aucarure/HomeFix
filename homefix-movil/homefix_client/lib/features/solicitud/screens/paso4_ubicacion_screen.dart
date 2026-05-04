import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/solicitud_model.dart';
import 'paso5_prioridad_screen.dart';

class Paso4UbicacionScreen extends StatefulWidget {
  final SolicitudModel solicitud;

  const Paso4UbicacionScreen({super.key, required this.solicitud});

  @override
  State<Paso4UbicacionScreen> createState() => _Paso4UbicacionScreenState();
}

class _Paso4UbicacionScreenState extends State<Paso4UbicacionScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.solicitud.direccion == null) {
      widget.solicitud.direccion = 'Av. Javier Prado 1234';
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
          children: [
            const Text(
              'Nueva solicitud',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'Paso 4 de 6',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 4 / 6,
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
                    'Confirma tu ubicación',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Puedes ajustarla moviendo el marcador.',
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 32),
                  // Mapa Simulado
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on, color: AppColors.primary, size: 40),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Dirección
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.solicitud.direccion!,
                                style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'San Isidro, Lima 15036',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Editar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Paso5PrioridadScreen(solicitud: widget.solicitud),
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
