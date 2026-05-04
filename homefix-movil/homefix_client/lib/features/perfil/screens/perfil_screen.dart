import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'cupones_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Mi perfil',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserSection(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildOptionsMenu(context),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32, // Tamaño 64 de diámetro
            backgroundColor: Color(0xFFEEEEEE),
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=anaperez'),
            child: Text('AP', style: TextStyle(color: AppColors.textGrey)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ana Pérez',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ana.perez@mail.com',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '+51 987 654 321',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsMenu(BuildContext context) {
    return Column(
      children: [
        _buildOptionItem(
          icon: Icons.person_outline,
          title: 'Editar datos personales',
          onTap: () {},
        ),
        _buildOptionItem(
          icon: Icons.location_on_outlined,
          title: 'Direcciones guardadas',
          onTap: () {},
        ),
        _buildOptionItem(
          icon: Icons.local_offer_outlined,
          title: 'Mis cupones',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CuponesScreen()),
            );
          },
        ),
        _buildOptionItem(
          icon: Icons.lock_outline,
          title: 'Cambiar contraseña',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Color(0xFFE53935), size: 24),
            ),
            const SizedBox(width: 16),
            const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
