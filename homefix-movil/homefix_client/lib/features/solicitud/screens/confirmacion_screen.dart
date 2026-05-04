import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ConfirmacionScreen extends StatelessWidget {
  const ConfirmacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
              ),
              const SizedBox(height: 32),
              const Text('¡Pago confirmado!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const Text(
                'Tu comprobante digital fue enviado a tu correo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textGrey),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('COMPROBANTE', style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 24),
                    _buildCompRow('Servicio', 'Electricidad', AppColors.primary),
                    const SizedBox(height: 12),
                    _buildCompRow('Técnico', 'Carlos Mendoza', AppColors.primary),
                    const SizedBox(height: 12),
                    _buildCompRow('Método', 'Yape', AppColors.textDark),
                    const SizedBox(height: 12),
                    _buildCompRow('Total pagado', 'S/. 85', AppColors.textDark, isBold: true),
                    const SizedBox(height: 12),
                    _buildCompRow('Nº operación', 'HF-248571', AppColors.textGrey),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Vuelve a Home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Calificar servicio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}
