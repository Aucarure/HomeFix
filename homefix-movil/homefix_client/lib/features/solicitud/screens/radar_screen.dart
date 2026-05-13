import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/ofertas_service.dart';
import '../models/solicitud_model.dart';
import 'ofertas_screen.dart';

// Etapas del radar: cada etapa define el rango en km y cuántos segundos dura
const _etapas = [
  _Etapa(rangoKm: 2, duracionSeg: 90),
  _Etapa(rangoKm: 5, duracionSeg: 90),
  _Etapa(rangoKm: 10, duracionSeg: 9999), // última etapa, sin límite
];

class _Etapa {
  final double rangoKm;
  final int duracionSeg;
  const _Etapa({required this.rangoKm, required this.duracionSeg});
}

class RadarScreen extends StatefulWidget {
  final String solicitudId;
  final SolicitudModel solicitud;

  const RadarScreen({
    super.key,
    required this.solicitudId,
    required this.solicitud,
  });

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with TickerProviderStateMixin {
  late AnimationController _radarController;
  final MapController _mapController = MapController();

  List<Oferta> _todasLasOfertas = [];   // todas las que llegaron del backend
  List<Oferta> _ofertasVisibles = [];   // filtradas por rango actual
  List<Oferta> _ofertasAnimadas = [];   // subconjunto ya "aparecido" con animación

  bool _cargando = true;
  int _etapaActual = 0;                 // índice en _etapas
  double get _rangoActualKm => _etapas[_etapaActual].rangoKm;

  Timer? _pollingTimer;
  Timer? _etapaTimer;
  Timer? _sinOfertasTimer;
  bool _mostroDialogoSinOfertas = false;

  // Para la animación de aparición de nuevos marcadores
  final Set<String> _idsYaAnimados = {};

  LatLng get _miUbicacion => LatLng(
        widget.solicitud.latitud ?? -12.0464,
        widget.solicitud.longitud ?? -77.0428,
      );

  // ── Distancia Haversine ────────────────────────────────────────────────────
  double _distanciaKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * pi / 180;

  // ── Init ───────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _cargarOfertas();

    // Polling cada 10 segundos
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) => _cargarOfertas());

    // Avanzar etapa de rango
    _programarSiguienteEtapa();

    // A los 5 min sin ninguna oferta, mostrar diálogo
    _sinOfertasTimer = Timer(const Duration(minutes: 5), _mostrarDialogoSinOfertas);
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pollingTimer?.cancel();
    _etapaTimer?.cancel();
    _sinOfertasTimer?.cancel();
    super.dispose();
  }

  // ── Etapas de rango ────────────────────────────────────────────────────────
  void _programarSiguienteEtapa() {
    if (_etapaActual >= _etapas.length - 1) return; // ya en la última
    _etapaTimer?.cancel();
    _etapaTimer = Timer(
      Duration(seconds: _etapas[_etapaActual].duracionSeg),
      () {
        if (!mounted) return;
        setState(() => _etapaActual++);
        _aplicarFiltroRango();
        _programarSiguienteEtapa();
      },
    );
  }

  // ── Carga y filtrado ───────────────────────────────────────────────────────
  Future<void> _cargarOfertas() async {
    try {
      final ofertas = await OfertasService.getOfertas(widget.solicitudId);
      if (!mounted) return;
      setState(() {
        _todasLasOfertas = ofertas;
        _cargando = false;
      });
      _aplicarFiltroRango();

      // Si hay al menos 1 oferta, cancelar el timer de "sin ofertas"
      if (ofertas.isNotEmpty) {
        _sinOfertasTimer?.cancel();
        _mostroDialogoSinOfertas = false;
      }
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _aplicarFiltroRango() {
    final dentroDeRango = _todasLasOfertas.where((o) {
      if (o.latitud == null || o.longitud == null) return false;
      final dist = _distanciaKm(
        _miUbicacion.latitude,
        _miUbicacion.longitude,
        o.latitud!,
        o.longitud!,
      );
      return dist <= _rangoActualKm;
    }).toList();

    setState(() => _ofertasVisibles = dentroDeRango);

    // Animar solo los que son nuevos
    for (final oferta in dentroDeRango) {
      if (!_idsYaAnimados.contains(oferta.id)) {
        _idsYaAnimados.add(oferta.id);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _ofertasAnimadas.add(oferta));
        });
      }
    }
  }

  // ── Diálogo sin ofertas (tipo inDrive) ─────────────────────────────────────
  void _mostrarDialogoSinOfertas() {
    if (!mounted || _mostroDialogoSinOfertas) return;
    if (_todasLasOfertas.isNotEmpty) return;
    _mostroDialogoSinOfertas = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _SinOfertasSheet(
        precioActual: widget.solicitud.precioSugerido,
        onAumentarPrecio: () {
          Navigator.pop(context);
          _mostrarDialogoAumentarPrecio();
        },
        onEsperar: () {
          Navigator.pop(context);
          // Reiniciar timer otros 3 min
          _sinOfertasTimer = Timer(const Duration(minutes: 3), _mostrarDialogoSinOfertas);
          _mostroDialogoSinOfertas = false;
        },
        onCancelar: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _mostrarDialogoAumentarPrecio() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AumentarPrecioSheet(
        precioActual: widget.solicitud.precioSugerido ?? 0,
        onConfirmar: (nuevoPrecio) {
          Navigator.pop(context);
          setState(() => widget.solicitud.precioSugerido = nuevoPrecio);
          // Reiniciar timers
          _sinOfertasTimer?.cancel();
          _mostroDialogoSinOfertas = false;
          _sinOfertasTimer = Timer(const Duration(minutes: 5), _mostrarDialogoSinOfertas);
        },
      ),
    );
  }

  // ── Click en card → mover mapa ─────────────────────────────────────────────
  void _irATecnico(Oferta oferta) {
    if (oferta.latitud == null || oferta.longitud == null) return;
    _mapController.move(LatLng(oferta.latitud!, oferta.longitud!), 16);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Mapa ──
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _miUbicacion,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.homefix.app',
              ),
              // Círculo de rango
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _miUbicacion,
                    radius: _rangoActualKm * 1000, // metros
                    useRadiusInMeter: true,
                    color: AppColors.primary.withOpacity(0.06),
                    borderColor: AppColors.primary.withOpacity(0.25),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Marcador del cliente
                  Marker(
                    point: _miUbicacion,
                    width: 60,
                    height: 60,
                    child: AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60 * _radarController.value,
                              height: 60 * _radarController.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(
                                    (1 - _radarController.value) * 0.4),
                              ),
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Marcadores de técnicos (solo los animados)
                  ..._ofertasAnimadas
                      .where((o) => o.latitud != null && o.longitud != null)
                      .map((o) => Marker(
                            point: LatLng(o.latitud!, o.longitud!),
                            width: 48,
                            height: 48,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) => Transform.scale(
                                scale: value,
                                child: GestureDetector(
                                  onTap: () => _irATecnico(o),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.primary, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        o.nombreTecnico[0],
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ],
              ),
            ],
          ),

          // ── Badge superior con rango actual ──
          Positioned(
            top: 52,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) => Opacity(
                        opacity: _radarController.value > 0.5 ? 1.0 : 0.2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _cargando
                          ? 'Buscando técnicos...'
                          : '${_ofertasVisibles.length} técnico${_ofertasVisibles.length != 1 ? 's' : ''} · ${_rangoActualKm.toInt()} km',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Sheet inferior ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_cargando)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  else ...[
                    SizedBox(
                      height: 170,
                      child: _ofertasVisibles.isEmpty
                          ? Center(
                              child: Text(
                                'Buscando en ${_rangoActualKm.toInt()} km...',
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 14),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _ofertasVisibles.length,
                              itemBuilder: (context, i) =>
                                  _buildTecnicoCard(_ofertasVisibles[i]),
                            ),
                    ),
                    if (_ofertasVisibles.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OfertasScreen(
                                solicitudId: widget.solicitudId,
                                ofertas: _todasLasOfertas,
                                solicitud: widget.solicitud,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Ver todas las ofertas',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTecnicoCard(Oferta oferta) {
    return GestureDetector(
      onTap: () => _irATecnico(oferta),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: oferta.fotoPerfil != null
                  ? NetworkImage(oferta.fotoPerfil!)
                  : null,
              child: oferta.fotoPerfil == null
                  ? Text(oferta.nombreTecnico[0],
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              oferta.nombreTecnico.split(' ').first,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textDark),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              oferta.mensaje,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textGrey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'S/. ${oferta.precioOfertado.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet: sin ofertas a los 5 min
// ─────────────────────────────────────────────────────────────────────────────
class _SinOfertasSheet extends StatelessWidget {
  final double? precioActual;
  final VoidCallback onAumentarPrecio;
  final VoidCallback onEsperar;
  final VoidCallback onCancelar;

  const _SinOfertasSheet({
    required this.precioActual,
    required this.onAumentarPrecio,
    required this.onEsperar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😕', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'Aún no hay técnicos disponibles',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            precioActual != null
                ? 'Tu precio actual es S/. ${precioActual!.toStringAsFixed(0)}. Aumentarlo puede atraer más técnicos.'
                : 'Aumentar el precio ofrecido puede atraer más técnicos.',
            style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Opción 1: Aumentar precio
          _BotonOpcion(
            icono: Icons.trending_up_rounded,
            titulo: 'Aumentar mi precio',
            subtitulo: 'Atrae más técnicos rápido',
            color: AppColors.primary,
            onTap: onAumentarPrecio,
          ),
          const SizedBox(height: 10),
          // Opción 2: Esperar
          _BotonOpcion(
            icono: Icons.access_time_rounded,
            titulo: 'Seguir esperando',
            subtitulo: 'Te avisaremos si alguien aparece',
            color: Colors.grey.shade700,
            onTap: onEsperar,
          ),
          const SizedBox(height: 10),
          // Opción 3: Cancelar
          _BotonOpcion(
            icono: Icons.close_rounded,
            titulo: 'Cancelar solicitud',
            subtitulo: 'Puedes volver a intentarlo después',
            color: Colors.red.shade400,
            onTap: onCancelar,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _BotonOpcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _BotonOpcion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Icon(icono, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: color)),
                  Text(subtitulo,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet: aumentar precio
// ─────────────────────────────────────────────────────────────────────────────
class _AumentarPrecioSheet extends StatefulWidget {
  final double precioActual;
  final void Function(double) onConfirmar;

  const _AumentarPrecioSheet({
    required this.precioActual,
    required this.onConfirmar,
  });

  @override
  State<_AumentarPrecioSheet> createState() => _AumentarPrecioSheetState();
}

class _AumentarPrecioSheetState extends State<_AumentarPrecioSheet> {
  late double _nuevoPrecio;

  @override
  void initState() {
    super.initState();
    _nuevoPrecio = widget.precioActual + 20; // sugerencia inicial +20
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ajusta tu precio',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Precio actual: S/. ${widget.precioActual.toStringAsFixed(0)}',
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            Text(
              'S/. ${_nuevoPrecio.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            Slider(
              value: _nuevoPrecio,
              min: widget.precioActual,
              max: widget.precioActual + 150,
              divisions: 15,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _nuevoPrecio = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [20, 50, 100].map((inc) {
                return OutlinedButton(
                  onPressed: () => setState(
                      () => _nuevoPrecio = widget.precioActual + inc),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text('+$inc',
                      style: const TextStyle(color: AppColors.primary)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => widget.onConfirmar(_nuevoPrecio),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirmar nuevo precio',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}