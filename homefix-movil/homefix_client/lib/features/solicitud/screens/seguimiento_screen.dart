import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'pago_screen.dart';

class SeguimientoScreen extends StatelessWidget {
  const SeguimientoScreen({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Seguimiento',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Servicio en curso',
              style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de progreso de pasos
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStepNode(true, true),
                _buildStepLine(true),
                _buildStepNode(true, true),
                _buildStepLine(true),
                _buildStepNode(true, false), // activo
                _buildStepLine(false),
                _buildStepNode(false, false),
                _buildStepLine(false),
                _buildStepNode(false, false),
              ],
            ),
          ),
          
          // Mapa simulado
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  left: 60,
                  child: const CircleAvatar(radius: 16, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: AppColors.white, size: 20)),
                ),
                Positioned(
                  top: 100,
                  right: 80,
                  child: const CircleAvatar(radius: 20, backgroundColor: AppColors.textDark, child: Icon(Icons.home, color: AppColors.white)),
                ),
                Positioned(
                  top: 80,
                  left: 100,
                  child: CustomPaint(
                    painter: _DashLinePainter(),
                    size: const Size(120, 20),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.schedule, color: AppColors.primary, size: 16),
                        SizedBox(width: 8),
                        Text('Llega en 12 min', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Chat
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text('Mensajes con tu técnico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChatBubble('Hola, ya estoy en camino 🔥', isMe: false),
                const SizedBox(height: 12),
                _buildChatBubble('Perfecto, gracias. Toca al timbre 2B.', isMe: true),
              ],
            ),
          ),
          
          // Chat Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
            child: Row(
              children: [
                const Icon(Icons.image, color: AppColors.textGrey),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
                    child: const Text('Escribe un mensaje...', style: TextStyle(color: AppColors.textGrey)),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: AppColors.white, size: 18),
                ),
              ],
            ),
          ),
          
          // Footer Fijo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=carlos'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Carlos Mendoza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                      Text('+51 987 654 321', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PagoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Verde success
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Finalizar →', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(bool isCompleted, bool isPast) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primary : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: isPast ? const Icon(Icons.check, color: AppColors.white, size: 14) : null,
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? AppColors.primary : Colors.grey[300],
      ),
    );
  }

  Widget _buildChatBubble(String text, {required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? AppColors.white : AppColors.textDark,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0.0;
    
    // Diagonal aprox path
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, startX * 0.2), Offset(startX + dashWidth, (startX + dashWidth) * 0.2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
