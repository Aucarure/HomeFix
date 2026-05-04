import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CuponesScreen extends StatelessWidget {
  const CuponesScreen({super.key});

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mis puntos',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFidelizacionCard(),
            const SizedBox(height: 24),
            _buildNivelesRecompensa(),
            const SizedBox(height: 24),
            _buildMisCupones(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFidelizacionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'FIDELIZACIÓN HOMEFIX',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.card_giftcard, color: AppColors.white, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '18 servicios',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Te faltan 12 para tu próximo cupón de 15%',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 18 / 30,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: TextStyle(color: AppColors.white.withOpacity(0.8), fontSize: 12)),
              Text('30', style: TextStyle(color: AppColors.white.withOpacity(0.8), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNivelesRecompensa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Niveles de recompensa',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildNivelItem(
          icon: Icons.check,
          iconColor: AppColors.success,
          bgColor: AppColors.success.withOpacity(0.1),
          title: '15 servicios completados',
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
          subtitle: 'Cupón 10% de descuento',
          badge: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('GANADO', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        _buildNivelItem(
          icon: Icons.lock_outline,
          iconColor: AppColors.textGrey,
          bgColor: Colors.grey[200]!,
          title: '30 servicios completados',
          titleStyle: const TextStyle(color: AppColors.textDark),
          subtitle: 'Cupón 15% de descuento',
        ),
        const SizedBox(height: 12),
        _buildNivelItem(
          icon: Icons.lock_outline,
          iconColor: AppColors.textGrey,
          bgColor: Colors.grey[200]!,
          title: '45 servicios completados',
          titleStyle: const TextStyle(color: AppColors.textDark),
          subtitle: 'Cupón 15% de descuento',
        ),
        const SizedBox(height: 12),
        _buildNivelItem(
          icon: Icons.lock_outline,
          iconColor: AppColors.textGrey,
          bgColor: Colors.grey[200]!,
          title: '60 servicios completados',
          titleStyle: const TextStyle(color: AppColors.textDark),
          subtitle: 'Cupón 15% de descuento',
        ),
        const SizedBox(height: 12),
        const Text(
          '* El cupón aplica para cualquier categoría de servicio.',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNivelItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required TextStyle titleStyle,
    required String subtitle,
    Widget? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          if (badge != null) badge,
        ],
      ),
    );
  }

  Widget _buildMisCupones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis cupones',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_offer, color: AppColors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '10% OFF',
                      style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Vence 30 Jun 2025',
                      style: TextStyle(color: AppColors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('ACTIVO', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_offer, color: AppColors.textGrey, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '5% OFF',
                      style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Usado el 12 Mar 2025',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Text(
                'USADO',
                style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
