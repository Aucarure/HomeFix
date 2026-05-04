import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'ofertas_screen.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // Mapa oscuro simulado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              color: const Color(0xFF1A1A2E),
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),
          ),
          
          // Radar central animation
          Positioned(
            top: 230,
            left: MediaQuery.of(context).size.width / 2 - 100, // aproximado center left
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100 * _animationController.value,
                        height: 100 * _animationController.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(1 - _animationController.value),
                        ),
                      ),
                      Container(
                        width: 200 * _animationController.value,
                        height: 200 * _animationController.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity((1 - _animationController.value) * 0.5),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Avatares
          _buildRadarAvatar(top: 120, left: 60, borderColor: AppColors.primary),
          _buildRadarAvatar(top: 180, left: 180, borderColor: AppColors.primary, size: 48), // centro aproximado
          _buildRadarAvatar(top: 260, left: 240, borderColor: Colors.blue),
          _buildRadarAvatar(top: 300, left: 100, borderColor: AppColors.primary),

          // Chip arriba
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bolt, color: AppColors.primary, size: 16),
                    SizedBox(width: 8),
                    Text('Electricidad', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),

          // Badge Buscando
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _animationController.value > 0.5 ? 1.0 : 0.2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('En búsqueda...', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          // Sheet inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -10) {
                  // Swipe up
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const OfertasScreen()),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 24, bottom: 40),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Buscando técnicos cercanos...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('4 técnicos encontrados', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildTecnicoCard('Carlos', 'Elite', AppColors.primary, '4.9', 'S/.80'),
                          _buildTecnicoCard('Jorge', 'Pro', Colors.blue, '4.7', 'S/.95'),
                          _buildTecnicoCard('Andrés', 'Verificado', Colors.grey, '4.5', 'S/.70'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarAvatar({required double top, required double left, required Color borderColor, double size = 36}) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
          image: const DecorationImage(
            image: NetworkImage('https://i.pravatar.cc/150'),
          ),
        ),
      ),
    );
  }

  Widget _buildTecnicoCard(String nombre, String badge, Color badgeColor, String rating, String precio) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          const SizedBox(height: 8),
          Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(precio, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;
    
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
