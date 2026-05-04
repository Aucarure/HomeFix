import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'perfil_tecnico_screen.dart';
import 'seguimiento_screen.dart';

class OfertasScreen extends StatelessWidget {
  const OfertasScreen({super.key});

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
              'Ofertas recibidas',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              '3 técnicos ofertaron',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOfertaCard1(context),
            const SizedBox(height: 16),
            _buildOfertaCard2(context),
            const SizedBox(height: 16),
            _buildOfertaCard3(context),
            const SizedBox(height: 32),
            const Text(
              'Las ofertas se actualizan en tiempo real',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOfertaCard1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=carlos'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Carlos Mendoza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('Elite', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text('4.9 (184)', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.blue, size: 14),
                        SizedBox(width: 4),
                        Text('Identidad verificada', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.schedule, color: AppColors.textGrey, size: 14),
                        SizedBox(width: 4),
                        Text('Llega en 25 min', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const Text('S/. 80', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilTecnicoScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ver perfil', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SeguimientoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Aceptar oferta', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfertaCard2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=jorge'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Jorge Ramírez', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('Pro', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text('4.7 (92)', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.blue, size: 14),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.schedule, color: AppColors.textGrey, size: 14),
                        SizedBox(width: 4),
                        Text('Llega en 40 min', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Contraoferta', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  const Text('S/. 95', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                  const Text('S/. 80', style: TextStyle(color: AppColors.textGrey, decoration: TextDecoration.lineThrough, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilTecnicoScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ver perfil', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showNegociarBottomSheet(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.chat, size: 16, color: AppColors.primary),
                  label: const Text('Negociar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SeguimientoScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Aceptar S/. 95', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfertaCard3(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=andres'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Andrés Quispe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                          child: const Text('Verificado', style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text('4.5 (34)', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.blue, size: 14),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.schedule, color: AppColors.textGrey, size: 14),
                        SizedBox(width: 4),
                        Text('Llega en 1 h', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const Text('S/. 70', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilTecnicoScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ver perfil', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SeguimientoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Aceptar oferta', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNegociarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Negociar precio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                const Text('Ingresa tu nueva oferta para este técnico.', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                const SizedBox(height: 24),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'S/. ',
                    hintText: 'Ej. 85',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Enviar contraoferta', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
