import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/solicitud_model.dart';
import 'paso2_descripcion_screen.dart';

class Paso1CategoriaScreen extends StatefulWidget {
  final String? initialCategory;

  const Paso1CategoriaScreen({super.key, this.initialCategory});

  @override
  State<Paso1CategoriaScreen> createState() => _Paso1CategoriaScreenState();
}

class _Paso1CategoriaScreenState extends State<Paso1CategoriaScreen> {
  late SolicitudModel _solicitud;
  
  final List<Map<String, dynamic>> _categorias = [
    {'title': 'Electricidad', 'icon': Icons.bolt},
    {'title': 'Gasfitería', 'icon': Icons.build},
    {'title': 'Carpintería', 'icon': Icons.handyman},
    {'title': 'Aire/Refri.', 'icon': Icons.ac_unit},
    {'title': 'Cerrajería', 'icon': Icons.key},
    {'title': 'Instalación', 'icon': Icons.tv},
  ];

  @override
  void initState() {
    super.initState();
    _solicitud = SolicitudModel(categoria: widget.initialCategory);
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
              'Paso 1 de 6',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1 / 6,
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
                    '¿Qué necesitas reparar?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Elige una categoría',
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      final cat = _categorias[index];
                      final isSelected = _solicitud.categoria == cat['title'];
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _solicitud.categoria = cat['title'] as String;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF5F0) : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                color: isSelected ? AppColors.primary : AppColors.textGrey,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                cat['title'] as String,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primary : AppColors.textDark,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                onPressed: _solicitud.categoria != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Paso2DescripcionScreen(solicitud: _solicitud),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
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
