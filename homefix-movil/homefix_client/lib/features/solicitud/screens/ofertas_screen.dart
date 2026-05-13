import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/ofertas_service.dart';
import '../models/solicitud_model.dart';
import 'perfil_tecnico_screen.dart';
import 'radar_screen.dart';
import 'seguimiento_screen.dart';

class OfertasScreen extends StatefulWidget {
  final String solicitudId;
  final List<Oferta> ofertas;
  final SolicitudModel solicitud;

  const OfertasScreen({
    super.key,
    required this.solicitudId,
    required this.ofertas,
    required this.solicitud,
  });

  @override
  State<OfertasScreen> createState() => _OfertasScreenState();
}

class _OfertasScreenState extends State<OfertasScreen> {
  late List<Oferta> _ofertas;
  // Polling timers por oferta en negociación
  final Map<String, Timer> _pollingTimers = {};

  @override
  void initState() {
    super.initState();
    _ofertas = List.from(widget.ofertas);
    // Iniciar polling para ofertas que ya estaban en negociando
    for (final o in _ofertas) {
      if (o.estado == 'negociando') _iniciarPolling(o.id);
    }
  }

  @override
  void dispose() {
    for (final t in _pollingTimers.values) t.cancel();
    super.dispose();
  }

  double _distanciaKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _rad(double deg) => deg * pi / 180;

  String _tiempoEstimado(double km) {
    final minutos = (km / 30 * 60).round();
    if (minutos < 5) return 'menos de 5 min';
    if (minutos < 60) return '~$minutos min';
    final h = minutos ~/ 60;
    final m = minutos % 60;
    return m == 0 ? '~${h}h' : '~${h}h ${m}min';
  }

  void _iniciarPolling(String ofertaId) {
    _pollingTimers[ofertaId]?.cancel();
    _pollingTimers[ofertaId] = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _verificarEstado(ofertaId),
    );
  }

  Future<void> _verificarEstado(String ofertaId) async {
    try {
      final data = await OfertasService.getEstado(ofertaId);
      final nuevoEstado = data['estado'] as String;

      if (!mounted) return;

      if (nuevoEstado == 'aceptado' || nuevoEstado == 'cancelado') {
        _pollingTimers[ofertaId]?.cancel();
        _pollingTimers.remove(ofertaId);

        setState(() {
          final idx = _ofertas.indexWhere((o) => o.id == ofertaId);
          if (idx == -1) return;
          final o = _ofertas[idx];
          _ofertas[idx] = Oferta(
            id: o.id,
            precioOfertado: o.precioOfertado,
            precioNegociado: o.precioNegociado,
            mensaje: o.mensaje,
            estado: nuevoEstado,
            usuarioId: o.usuarioId,
            nombreTecnico: o.nombreTecnico,
            fotoPerfil: o.fotoPerfil,
            latitud: o.latitud,
            longitud: o.longitud,
          );
        });

        if (nuevoEstado == 'cancelado') {
          _mostrarSnack('${_getNombre(ofertaId)} rechazó tu contraoferta', esError: true);
        } else {
          _mostrarSnack('¡${_getNombre(ofertaId)} aceptó tu contraoferta!');
        }
      }
    } catch (_) {}
  }

  String _getNombre(String ofertaId) {
    return _ofertas
        .firstWhere((o) => o.id == ofertaId, orElse: () => _ofertas.first)
        .nombreTecnico
        .split(' ')
        .first;
  }

  void _mostrarSnack(String msg, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: esError ? Colors.redAccent : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _enviarNegociacion(Oferta oferta, double precio) async {
    try {
      await OfertasService.negociar(oferta.id, precio);
      setState(() {
        final idx = _ofertas.indexWhere((o) => o.id == oferta.id);
        _ofertas[idx] = Oferta(
          id: oferta.id,
          precioOfertado: oferta.precioOfertado,
          precioNegociado: precio,
          mensaje: oferta.mensaje,
          estado: 'negociando',
          usuarioId: oferta.usuarioId,
          nombreTecnico: oferta.nombreTecnico,
          fotoPerfil: oferta.fotoPerfil,
          latitud: oferta.latitud,
          longitud: oferta.longitud,
        );
      });
      _iniciarPolling(oferta.id);
    } catch (_) {
      _mostrarSnack('Error al enviar contraoferta', esError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RadarScreen(
                solicitudId: widget.solicitudId,
                solicitud: widget.solicitud,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RadarScreen(
                  solicitudId: widget.solicitudId,
                  solicitud: widget.solicitud,
                ),
              ),
            ),
          ),
          title: Column(
            children: [
              const Text('Ofertas recibidas',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text(
                '${_ofertas.length} técnico${_ofertas.length != 1 ? 's' : ''} ofertaron',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
        body: _ofertas.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, color: AppColors.textGrey, size: 48),
                    SizedBox(height: 16),
                    Text('Aún no hay ofertas',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Los técnicos están revisando tu solicitud.',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ..._ofertas.map((o) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildOfertaCard(context, o),
                        )),
                    const SizedBox(height: 16),
                    const Text('Las ofertas se actualizan en tiempo real',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOfertaCard(BuildContext context, Oferta oferta) {
    final userLat = widget.solicitud.latitud;
    final userLon = widget.solicitud.longitud;
    String? tiempoTexto;
    String? distanciaTexto;

    if (userLat != null && userLon != null &&
        oferta.latitud != null && oferta.longitud != null) {
      final km = _distanciaKm(userLat, userLon, oferta.latitud!, oferta.longitud!);
      distanciaTexto = km < 1
          ? '${(km * 1000).round()} m'
          : '${km.toStringAsFixed(1)} km';
      tiempoTexto = _tiempoEstimado(km);
    }

    final estaNegociando = oferta.estado == 'negociando';
    final fueAceptado = oferta.estado == 'aceptado';
    final fueCancelado = oferta.estado == 'cancelado';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fueCancelado
            ? Colors.grey[50]
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: fueCancelado
            ? Border.all(color: Colors.grey[300]!)
            : fueAceptado
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
        boxShadow: fueCancelado
            ? null
            : [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: oferta.fotoPerfil != null
                    ? NetworkImage(oferta.fotoPerfil!)
                    : null,
                child: oferta.fotoPerfil == null
                    ? Text(oferta.nombreTecnico[0],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(oferta.nombreTecnico,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textDark)),
                    if (tiempoTexto != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: AppColors.textGrey),
                          const SizedBox(width: 2),
                          Text(distanciaTexto!,
                              style: const TextStyle(
                                  color: AppColors.textGrey, fontSize: 11)),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 2),
                          Text(tiempoTexto,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(oferta.mensaje,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (oferta.precioNegociado != null) ...[
                    Text(
                      'S/. ${oferta.precioOfertado.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      'S/. ${oferta.precioNegociado!.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ] else
                    Text(
                      'S/. ${oferta.precioOfertado.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Banner de estado
          if (estaNegociando)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Esperando respuesta del técnico...',
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )
          else if (fueAceptado)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(
                    '¡El técnico aceptó tu contraoferta!',
                    style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          else if (fueCancelado)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.cancel, size: 14, color: Colors.red[700]),
                  const SizedBox(width: 8),
                  Text(
                    'El técnico rechazó tu contraoferta',
                    style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Botones
          if (!estaNegociando && !fueCancelado)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PerfilTecnicoScreen(
                          usuarioId: oferta.usuarioId,
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Ver perfil',
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
                // Botón negociar solo si no hay negociación previa y no fue aceptado
                if (oferta.precioNegociado == null && !fueAceptado) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showNegociarBottomSheet(context, oferta),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.chat,
                          size: 16, color: AppColors.primary),
                      label: const Text('Negociar',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SeguimientoScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Aceptar',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showNegociarBottomSheet(BuildContext context, Oferta oferta) {
    final controller = TextEditingController();
    bool enviando = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Negociar con ${oferta.nombreTecnico.split(' ').first}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Precio actual: S/. ${oferta.precioOfertado.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: 'S/. ',
                        hintText: 'Tu precio',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: enviando
                            ? null
                            : () async {
                                final precio =
                                    double.tryParse(controller.text.trim());
                                if (precio == null || precio <= 0) return;
                                setModalState(() => enviando = true);
                                Navigator.pop(context);
                                await _enviarNegociacion(oferta, precio);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: enviando
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Enviar contraoferta',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}