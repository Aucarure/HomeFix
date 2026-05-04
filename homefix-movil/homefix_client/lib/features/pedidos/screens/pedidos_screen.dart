import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final List<String> _filters = ['Todos', 'Completado', 'En curso', 'Cancelado'];
  String _selectedFilter = 'Todos';

  // Datos mockeados para la UI
  final List<Map<String, dynamic>> _pedidos = [
    {
      'categoria': 'ELECTRICIDAD',
      'estado': 'Completado',
      'tecnico': 'Carlos Mendoza',
      'fecha': '12 Mar 2025',
      'precio': 'S/. 80',
    },
    {
      'categoria': 'GASFITERÍA',
      'estado': 'En curso',
      'tecnico': 'Luis Torres',
      'fecha': 'Hoy, 10:30 AM',
      'precio': 'S/. 120',
    },
    {
      'categoria': 'CERRAJERÍA',
      'estado': 'Cancelado',
      'tecnico': 'Jorge Ramírez',
      'fecha': '18 Feb 2025',
      'precio': 'S/. 60',
    },
    {
      'categoria': 'CARPINTERÍA',
      'estado': 'Completado',
      'tecnico': 'Pedro Pablo',
      'fecha': '05 Ene 2025',
      'precio': 'S/. 250',
    },
  ];

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
            // Aquí puedes manejar la navegación si es necesario
          },
        ),
        title: const Text(
          'Mis pedidos',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildPedidosList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.textGrey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPedidosList() {
    final filteredPedidos = _selectedFilter == 'Todos'
        ? _pedidos
        : _pedidos.where((p) => p['estado'] == _selectedFilter).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPedidos.length,
      itemBuilder: (context, index) {
        final pedido = filteredPedidos[index];
        return _buildPedidoCard(pedido);
      },
    );
  }

  Widget _buildPedidoCard(Map<String, dynamic> pedido) {
    Color statusColor;
    Color statusBgColor;

    switch (pedido['estado']) {
      case 'Completado':
        statusColor = AppColors.success;
        statusBgColor = AppColors.success.withOpacity(0.1);
        break;
      case 'En curso':
        statusColor = AppColors.primary;
        statusBgColor = AppColors.primary.withOpacity(0.1);
        break;
      case 'Cancelado':
      default:
        statusColor = AppColors.textGrey;
        statusBgColor = Colors.grey[200]!;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pedido['categoria'],
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pedido['estado'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pedido['tecnico'],
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pedido['fecha'],
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                ),
              ),
              Text(
                pedido['precio'],
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
