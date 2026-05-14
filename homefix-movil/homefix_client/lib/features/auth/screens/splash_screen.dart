import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'login_screen.dart';
import '../../../main.dart';          // ← CAMBIA este import
import '../../../core/services/session_service.dart'; // agregar
import '../../../core/services/api_client.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
  await Future.delayed(const Duration(seconds: 2));

  final session = Supabase.instance.client.auth.currentSession;

  if (!mounted) return;

  if (session != null) {
    // Cargar datos del usuario en SessionService
    try {
      final data = await ApiClient.getMap('/usuarios/${session.user.id}');
      SessionService.guardar(data);
    } catch (e) {
      // Si falla igual navega
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_repair_service, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'HomeFix',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}