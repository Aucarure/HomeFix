import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import 'seguimiento_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PerfilTecnicoScreen extends StatefulWidget {
  final String usuarioId;
  const PerfilTecnicoScreen({super.key, required this.usuarioId});

  @override
  State<PerfilTecnicoScreen> createState() => _PerfilTecnicoScreenState();
}

class _PerfilTecnicoScreenState extends State<PerfilTecnicoScreen> {
  Map<String, dynamic>? _perfil;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final data = await ApiClient.getMap('/usuarios/${widget.usuarioId}/perfil');
      setState(() { _perfil = data; _cargando = false; });
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  void _abrirVisor(BuildContext context, String url, bool esPdf) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _VisorArchivoScreen(url: url, esPdf: esPdf)),
    );
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
        title: const Text('Perfil del técnico',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _perfil == null
              ? const Center(child: Text('No se pudo cargar el perfil'))
              : _buildPerfil(),
    );
  }

  Widget _buildPerfil() {
    final p = _perfil!;
    final nombre = p['nombre_completo'] ?? 'Técnico';
    final foto = p['foto_perfil_url'];
    final verificado = p['telefono_verificado'] == true;
    final edad = p['edad'];
    final promedio = p['promedio_estrellas'];
    final total = p['total_calificaciones'] ?? 0;
    final certificados = List<Map<String, dynamic>>.from(p['documentos'] ?? [])
        .where((d) => d['tipo'] == 'certificado')
        .toList();
    final calificaciones = List<Map<String, dynamic>>.from(p['calificaciones'] ?? []);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: foto != null ? NetworkImage(foto) : null,
                        child: foto == null
                            ? Text(nombre[0],
                                style: const TextStyle(
                                    fontSize: 36,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold))
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(nombre,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (verificado) ...[
                            const Icon(Icons.verified, color: Colors.blue, size: 16),
                            const SizedBox(width: 4),
                            const Text('Verificado',
                                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                            const SizedBox(width: 12),
                          ],
                          if (edad != null)
                            Text('$edad años',
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                        ],
                      ),
                      if (promedio != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text('$promedio ($total reseñas)',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textDark)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                if (certificados.isNotEmpty) ...[
                  const Text('Certificados',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: certificados.map((d) {
                      final url = d['url_archivo'] as String? ?? '';
                      final esPdf = url.toLowerCase().endsWith('.pdf');
                      return GestureDetector(
                        onTap: () => _abrirVisor(context, url, esPdf),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                esPdf ? Icons.picture_as_pdf : Icons.image,
                                size: 14,
                                color: esPdf ? Colors.red : AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(d['tipo'],
                                  style: const TextStyle(color: AppColors.textDark, fontSize: 13)),
                              const SizedBox(width: 4),
                              const Icon(Icons.open_in_new, size: 12, color: AppColors.textGrey),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                ],

                Row(
                  children: [
                    const Text('Reseñas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(width: 6),
                    Text('($total)', style: const TextStyle(fontSize: 16, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 12),

                if (calificaciones.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('Sin reseñas aún', style: TextStyle(color: AppColors.textGrey))),
                  )
                else
                  ...calificaciones.map((c) {
                    final reviewer = c['usuarios']?['nombre_completo'] ?? 'Usuario';
                    final estrellas = c['estrellas'] ?? 0;
                    final comentario = c['comentario'] ?? '';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[200],
                            child: Text(reviewer[0],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(reviewer,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                            fontSize: 13)),
                                    Row(
                                      children: List.generate(5, (i) => Icon(Icons.star,
                                          size: 13,
                                          color: i < estrellas ? Colors.amber : Colors.grey[300])),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(comentario,
                                    style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeguimientoScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Seleccionar este técnico',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
            ),
          ),
        ),
      ],
    );
  }
}

// ← Fuera de _PerfilTecnicoScreenState
class _VisorArchivoScreen extends StatelessWidget {
  final String url;
  final bool esPdf;

  const _VisorArchivoScreen({required this.url, required this.esPdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: esPdf
          ? SfPdfViewer.network(url)
          : InteractiveViewer(
              child: Center(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.white, size: 48),
                  ),
                ),
              ),
            ),
    );
  }
}