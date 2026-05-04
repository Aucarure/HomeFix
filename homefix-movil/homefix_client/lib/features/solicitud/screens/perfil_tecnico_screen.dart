import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'seguimiento_screen.dart';

class PerfilTecnicoScreen extends StatelessWidget {
  const PerfilTecnicoScreen({super.key});

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
          'Perfil del técnico',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60, // 120px diameter
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=carlos'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Carlos Mendoza', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Elite', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      const Text('Identidad verificada', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text('4.9 (184)', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('47 de 50', 'COMPLETADOS'),
                      _buildStatCard('5 min', 'RESPUESTA'),
                      _buildStatCard('8 años', 'EXPERIENCIA'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Zona de operación'),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: AppColors.primary),
                      SizedBox(width: 8),
                      Expanded(child: Text('San Isidro, Miraflores, Surco', style: TextStyle(color: AppColors.textDark, fontSize: 16))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Certificados'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip('Electricista certificado'),
                      const SizedBox(width: 12),
                      _buildChip('SENATI 2019'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Trabajos anteriores'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildWorkImage(Colors.orange[100]!)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildWorkImage(Colors.blue[100]!)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildWorkImage(Colors.green[100]!)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: const [
                      Text('Reseñas ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Text('(184)', style: TextStyle(fontSize: 18, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReviewCard('María G.', 'Excelente trabajo, llegó a tiempo y resolvió el problema rápido.', 5),
                  _buildReviewCard('Juan P.', 'Muy profesional. Recomendado.', 5),
                  _buildReviewCard('Lucía M.', 'Todo bien, aunque demoró 10 min en llegar.', 4),
                  const SizedBox(height: 32),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SeguimientoScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Seleccionar este técnico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
    );
  }

  Widget _buildWorkImage(Color color) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildReviewCard(String name, String comment, int stars) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Text(name[0], style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    Row(
                      children: List.generate(5, (index) => Icon(Icons.star, size: 14, color: index < stars ? Colors.amber : Colors.grey[300])),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
