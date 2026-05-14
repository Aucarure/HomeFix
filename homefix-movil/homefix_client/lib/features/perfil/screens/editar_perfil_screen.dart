import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _cargando = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    print('🔍 usuarioId: ${SessionService.usuarioId}'); // ← AGREGAR ESTA LÍNEA

    try {
      final data = await ApiClient.getMap('/usuarios/${SessionService.usuarioId}');
      _nombreController.text = data['nombre_completo'] ?? '';
      _telefonoController.text = data['telefono'] ?? '';
    } catch (e) {
      // Si falla usa los datos del SessionService
      _nombreController.text = SessionService.nombre ?? '';
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _guardar() async {
    if (_nombreController.text.trim().isEmpty) {
      _mostrarError('El nombre no puede estar vacío');
      return;
    }

    setState(() => _guardando = true);
    try {
      await ApiClient.patch('/usuarios/${SessionService.usuarioId}', {
        'nombre_completo': _nombreController.text.trim(),
        'telefono': _telefonoController.text.trim(),
      });

      // Actualizar SessionService con el nuevo nombre
      SessionService.nombre = _nombreController.text.trim();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos actualizados correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // true = hubo cambios
    } catch (e) {
      print('❌ ERROR GUARDAR: $e'); // ← AGREGAR

      _mostrarError('Error al guardar. Intenta de nuevo.');
    } finally {
      setState(() => _guardando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
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
        title: const Text(
          'Editar datos personales',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Avatar grande
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      (SessionService.nombre?.isNotEmpty == true)
                          ? SessionService.nombre![0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Correo (solo lectura)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, color: Colors.grey[500]),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correo electrónico',
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              Supabase.instance.client.auth.currentUser?.email ?? '',
                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.lock_outline, size: 16, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Teléfono
                  TextField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _guardando ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _guardando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Guardar cambios',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}