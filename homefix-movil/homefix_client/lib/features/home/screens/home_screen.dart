import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../solicitud/screens/paso1_categoria_screen.dart';
import '../../../core/services/session_service.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderWithSearch(context),
            const SizedBox(height: 32), // Add extra space since search overlaps
            _buildActiveRequestCard(),
            const SizedBox(height: 24),
            _buildCategoriesSection(),
            const SizedBox(height: 24),
            _buildRecentHistorySection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderWithSearch(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final nombre = SessionService.nombre ?? 'Usuario';
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: topPadding > 0 ? topPadding + 20 : 60,
              left: 24,
              right: 24,
              bottom: 40),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hola,',
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$nombre 👋',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: AppColors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Lima, Perú',
                        style: TextStyle(color: AppColors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Text(
                  inicial,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -25,
          left: 16,
          right: 16,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search, color: AppColors.textGrey),
                const SizedBox(width: 12),
                Text(
                  '¿Qué necesitas reparar hoy?',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildActiveRequestCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Solicitud activa',
                  style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Ver >',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reparación eléctrica',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Carlos Mendoza · En camino',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'EN VIVO',
                    style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'title': 'Electricidad', 'icon': Icons.bolt, 'color': const Color(0xFFFFF9E6)},
      {'title': 'Gasfitería', 'icon': Icons.build, 'color': const Color(0xFFE8F4FD)},
      {'title': 'Carpintería', 'icon': Icons.handyman, 'color': const Color(0xFFFFF0E6)},
      {'title': 'Aire/Refri.', 'icon': Icons.ac_unit, 'color': const Color(0xFFE6F7FF)},
      {'title': 'Cerrajería', 'icon': Icons.key, 'color': const Color(0xFFF3E6FF)},
      {'title': 'Instalación', 'icon': Icons.tv, 'color': const Color(0xFFE6FFE6)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorías',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Paso1CategoriaScreen(initialCategory: cat['title'] as String),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cat['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat['icon'] as IconData, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['title'] as String,
                      style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHistorySection() {
    final history = [
      {'initial': 'E', 'title': 'Electricidad', 'subtitle': 'Carlos Mendoza · 12 Mar 2025', 'price': 'S/. 80'},
      {'initial': 'G', 'title': 'Gasfitería', 'subtitle': 'Luis Torres · 03 Mar 2025', 'price': 'S/. 120'},
      {'initial': 'C', 'title': 'Cerrajería', 'subtitle': 'Jorge Ramírez · 18 Feb 2025', 'price': 'S/. 60'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial reciente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              Text(
                'Ver todo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...history.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        item['initial']!,
                        style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['subtitle']!,
                            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['price']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
