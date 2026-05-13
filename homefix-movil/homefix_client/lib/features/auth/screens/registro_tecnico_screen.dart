import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegistroTecnicoScreen extends StatefulWidget {
  const RegistroTecnicoScreen({super.key});

  @override
  State<RegistroTecnicoScreen> createState() => _RegistroTecnicoScreenState();
}

class _RegistroTecnicoScreenState extends State<RegistroTecnicoScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  bool _cargando = false;
  bool _verPassword = false;
  bool _verConfirmarPassword = false;
  List<File> _certificados = [];

  Future<void> _seleccionarArchivos() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _certificados = result.paths
            .where((p) => p != null)
            .map((p) => File(p!))
            .toList();
      });
    }
  }

  Future<void> _registrar() async {
    if (_nombreController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmarPasswordController.text.isEmpty) {
      _mostrarError('Completa todos los campos');
      return;
    }
    if (_passwordController.text != _confirmarPasswordController.text) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }
    if (_passwordController.text.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (_certificados.isEmpty) {
      _mostrarError('Debes subir al menos un certificado');
      return;
    }

    setState(() => _cargando = true);

    try {
      await AuthService.registrarTecnico(
        nombreCompleto: _nombreController.text.trim(),
        correo: _correoController.text.trim(),
        telefono: _telefonoController.text.trim(),
        password: _passwordController.text.trim(),
        certificados: _certificados,
      );
      if (!mounted) return;
      _mostrarExito();
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            const Text(
              '¡Solicitud enviada!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu registro fue enviado. El equipo HomeFix revisará tus certificados y te notificará.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Entendido',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Registro de técnico'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Icon(Icons.engineering, size: 56, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre completo',
                icon: Icons.person_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _correoController,
                label: 'Correo electrónico',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock_outlined,
                obscureText: !_verPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                      _verPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () =>
                      setState(() => _verPassword = !_verPassword),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmarPasswordController,
                label: 'Confirmar contraseña',
                icon: Icons.lock_outlined,
                obscureText: !_verConfirmarPassword,
                suffixIcon: IconButton(
                  icon: Icon(_verConfirmarPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => setState(
                      () => _verConfirmarPassword = !_verConfirmarPassword),
                ),
              ),
              const SizedBox(height: 24),

              // SECCIÓN CERTIFICADOS
              const Text(
                'Certificados / Documentos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 6),
              Text(
                'Sube tus certificados técnicos (PDF, JPG, PNG)',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _seleccionarArchivos,
                icon: const Icon(Icons.upload_file),
                label: const Text('Seleccionar archivos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              if (_certificados.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: _certificados.map((archivo) {
                      final nombre = archivo.path.split('/').last;
                      return Row(
                        children: [
                          const Icon(Icons.insert_drive_file,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              nombre,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 18, color: Colors.red),
                            onPressed: () {
                              setState(() => _certificados.remove(archivo));
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enviar solicitud',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}