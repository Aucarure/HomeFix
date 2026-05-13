import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/solicitud_model.dart';
import 'radar_screen.dart';

class Paso5PrioridadScreen extends StatefulWidget {
  final SolicitudModel solicitud;

  const Paso5PrioridadScreen({super.key, required this.solicitud});

  @override
  State<Paso5PrioridadScreen> createState() => _Paso5PrioridadScreenState();
}

class _Paso5PrioridadScreenState extends State<Paso5PrioridadScreen> {
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
              'Paso 5 de 6',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 5 / 6,
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
                    '¿Destacar tu solicitud?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Opcional pero recomendado.',
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 32),
                  // Prioridad Card
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.solicitud.conPrioridad = !widget.solicitud.conPrioridad;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.solicitud.conPrioridad ? const Color(0xFFFFF5F0) : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.bolt, color: AppColors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'PRIORIDAD',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              Radio<bool>(
                                value: true,
                                groupValue: widget.solicitud.conPrioridad ? true : null,
                                activeColor: AppColors.primary,
                                onChanged: (val) {
                                  setState(() {
                                    widget.solicitud.conPrioridad = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '+ S/. 5 solo si es aceptado',
                            style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aumenta la visibilidad de tu pedido. Se cobran S/. 5 adicionales SOLO si un técnico acepta tu solicitud.',
                            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Resumen Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // gris claro
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RESUMEN',
                          style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 16),
                        // Reemplaza el resumen del precio en el Container de RESUMEN:
                        _buildResumenRow('Categoría', widget.solicitud.categoria ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildResumenRow(
                          'Precio base',
                          'S/. ${widget.solicitud.precioFinal?.toStringAsFixed(0) ?? '0'}',
                        ),
                        if (widget.solicitud.conPrioridad) ...[
                          const SizedBox(height: 12),
                          _buildResumenRow('Prioridad', '+ S/. 5'),
                        ],
                        const Divider(height: 24),
                        _buildResumenRow(
                          'Total',
                          'S/. ${((widget.solicitud.precioFinal ?? 0) + (widget.solicitud.conPrioridad ? 5 : 0)).toStringAsFixed(0)}',
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
                      builder: (_) => RadarScreen(
                        solicitudId: widget.solicitud.solicitudId ?? 'f1000000-0000-0000-0000-000000000001',
                        solicitud: widget.solicitud,
                      ),
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
                  'Publicar solicitud',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
        Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
