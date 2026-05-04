import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos estáticos
    final List<Map<String, dynamic>> notifications = [
      {
        'icon': Icons.chat_bubble_outline,
        'iconColor': AppColors.primary,
        'bgColor': AppColors.primary.withOpacity(0.1),
        'title': 'Nueva oferta recibida',
        'subtitle': 'Carlos Mendoza ofertó S/. 80 por tu solicitud',
        'time': 'hace 2 min',
        'isRead': false,
      },
      {
        'icon': Icons.local_shipping_outlined,
        'iconColor': Colors.blue,
        'bgColor': Colors.blue.withOpacity(0.1),
        'title': 'Tu técnico está en camino',
        'subtitle': 'Llegará en aproximadamente 25 min',
        'time': 'hace 30 min',
        'isRead': false,
      },
      {
        'icon': Icons.card_giftcard,
        'iconColor': Colors.amber,
        'bgColor': Colors.amber.withOpacity(0.15),
        'title': '¡Nuevo cupón desbloqueado!',
        'subtitle': 'Completaste 15 servicios. 10% de descuento disponible',
        'time': 'ayer',
        'isRead': true,
      },
      {
        'icon': Icons.check_circle_outline,
        'iconColor': AppColors.success,
        'bgColor': AppColors.success.withOpacity(0.1),
        'title': 'Servicio completado',
        'subtitle': 'Califica a Luis Torres',
        'time': 'hace 3 días',
        'isRead': true,
      },
      {
        'icon': Icons.credit_card,
        'iconColor': Colors.purple,
        'bgColor': Colors.purple.withOpacity(0.1),
        'title': 'Pago confirmado',
        'subtitle': 'S/. 120 pagados con Yape',
        'time': 'hace 3 días',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            // Manejar retroceso si es necesario
          },
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: item['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['iconColor'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                          height: 1.3, // Un ligero espaciado de línea mejora la legibilidad
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!(item['isRead'] as bool))
                  Container(
                    margin: const EdgeInsets.only(left: 12, top: 6),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
