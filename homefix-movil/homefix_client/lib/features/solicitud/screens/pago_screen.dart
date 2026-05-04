import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'confirmacion_screen.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  String _selectedMethod = 'Yape';

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
        title: const Text(
          'Pago',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
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
                  // Resumen
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RESUMEN DEL SERVICIO', style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        _buildRow('Categoría', 'Electricidad', AppColors.textDark),
                        const SizedBox(height: 12),
                        _buildRow('Técnico', 'Carlos Mendoza', AppColors.textDark),
                        const SizedBox(height: 12),
                        _buildRow('Precio acordado', 'S/. 80', AppColors.textDark),
                        const SizedBox(height: 12),
                        _buildRow('Prioridad', '+ S/. 5', AppColors.primary),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Colors.grey),
                        ),
                        _buildRow('Total', 'S/. 85', AppColors.textDark, isBold: true, fontSize: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Cupon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.local_offer, color: AppColors.success, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Cupón 10% de descuento', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              Text('Disponible por fidelización', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Switch(
                          value: false,
                          onChanged: (val) {},
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Metodos de pago
                  const Text('Método de pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildMethodCard('Yape', Icons.smartphone, 'Yape'),
                      _buildMethodCard('Plin', Icons.smartphone, 'Plin'),
                      _buildMethodCard('Tarjeta', Icons.credit_card, 'Tarjeta'),
                      _buildMethodCard('Efectivo', Icons.payments, 'Efectivo', sub: 'Pago al recibir'),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Bottom button
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
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfirmacionScreen()),
                    (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Confirmar pago · S/. 85', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color valueColor, {bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textGrey, fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: valueColor, fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.bold)),
      ],
    );
  }

  Widget _buildMethodCard(String title, IconData icon, String value, {String? sub}) {
    final isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F0) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textDark, size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textDark)),
            if (sub != null)
              Text(sub, style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
