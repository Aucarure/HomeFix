import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/direccion_model.dart';
import '../../../core/services/direcciones_service.dart';
import '../models/solicitud_model.dart';
import 'paso5_prioridad_screen.dart';

const String _usuarioIdTemporal = '6b6f3bd6-20ef-46b3-acc0-fd3ddbc7f7a9';
const LatLng _limaDefault = LatLng(-12.0464, -77.0428);

class Paso4UbicacionScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  const Paso4UbicacionScreen({super.key, required this.solicitud});

  @override
  State<Paso4UbicacionScreen> createState() => _Paso4UbicacionScreenState();
}

class _Paso4UbicacionScreenState extends State<Paso4UbicacionScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  List<DireccionModel> _direcciones = [];
  List<DireccionModel> _direccionesFiltradas = [];
  List<Map<String, dynamic>> _resultadosNominatim = [];

  DireccionModel? _seleccionada;
  LatLng _marcador = _limaDefault;
  bool _modoPersonalizado = false;
  bool _cargando = true;
  bool _buscando = false;
  bool _mostrarResultados = false;

  @override
  void initState() {
    super.initState();
    _cargarDirecciones();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarDirecciones() async {
    try {
      final dirs = await DireccionesService.getDirecciones(_usuarioIdTemporal);
      setState(() {
        _direcciones = dirs;
        _direccionesFiltradas = dirs;
        _seleccionada = dirs.isNotEmpty
            ? dirs.firstWhere((d) => d.esPredeterminada, orElse: () => dirs.first)
            : null;
        if (_seleccionada?.latitud != null && _seleccionada?.longitud != null) {
          _marcador = LatLng(_seleccionada!.latitud!, _seleccionada!.longitud!);
        }
        _cargando = false;
      });
      if (_seleccionada?.latitud != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _mapController.move(_marcador, 15);
        });
      }
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _direccionesFiltradas = _direcciones;
        _resultadosNominatim = [];
        _mostrarResultados = false;
      });
      return;
    }

    final filtradas = _direcciones.where((d) {
      final texto = '${d.etiqueta} ${d.direccion} ${d.distrito}'.toLowerCase();
      return texto.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _direccionesFiltradas = filtradas;
      _mostrarResultados = true;
      _buscando = true;
    });

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$query, Lima, Perú')}&format=json&limit=3&countrycodes=pe',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'homefix-app'});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _resultadosNominatim = data.map((e) => e as Map<String, dynamic>).toList();
          _buscando = false;
        });
      } else {
        setState(() => _buscando = false);
      }
    } catch (_) {
      setState(() => _buscando = false);
    }
  }

  void _seleccionarDireccion(DireccionModel dir) {
    setState(() {
      _seleccionada = dir;
      _modoPersonalizado = false;
      _mostrarResultados = false;
      _searchController.clear();
      if (dir.latitud != null && dir.longitud != null) {
        _marcador = LatLng(dir.latitud!, dir.longitud!);
        _mapController.move(_marcador, 15);
      }
    });
  }

  void _seleccionarResultadoNominatim(Map<String, dynamic> resultado) {
    final lat = double.tryParse(resultado['lat'] ?? '0') ?? 0;
    final lon = double.tryParse(resultado['lon'] ?? '0') ?? 0;
    final label = resultado['display_name'] ?? 'Ubicación encontrada';

    setState(() {
      _seleccionada = null;
      _modoPersonalizado = true;
      _marcador = LatLng(lat, lon);
      _mostrarResultados = false;
      _searchController.text = label;
      _mapController.move(_marcador, 16);
    });
  }

  void _activarModoPersonalizado() {
    setState(() {
      _seleccionada = null;
      _modoPersonalizado = true;
      _mostrarResultados = false;
    });
  }

  void _continuar() {
    if (_modoPersonalizado) {
      widget.solicitud.direccion = _searchController.text.isNotEmpty
          ? _searchController.text
          : 'Ubicación personalizada';
      widget.solicitud.latitud = _marcador.latitude;
      widget.solicitud.longitud = _marcador.longitude;
      widget.solicitud.direccionId = null;
    } else if (_seleccionada != null) {
      widget.solicitud.direccion = _seleccionada!.direccion;
      widget.solicitud.latitud = _seleccionada!.latitud;
      widget.solicitud.longitud = _seleccionada!.longitud;
      widget.solicitud.direccionId = _seleccionada!.id;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Paso5PrioridadScreen(solicitud: widget.solicitud),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final puedeContinar = _seleccionada != null || _modoPersonalizado;

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
          children: const [
            Text('Nueva solicitud',
                style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Paso 4 de 6',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 4 / 6,
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
                  const Text('Confirma tu ubicación',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('Selecciona una dirección o busca una nueva.',
                      style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar dirección...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, color: AppColors.textGrey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _direccionesFiltradas = _direcciones;
                                  _mostrarResultados = false;
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),

                  if (_mostrarResultados) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_direccionesFiltradas.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                              child: Text('Mis direcciones',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            ..._direccionesFiltradas.map((dir) => ListTile(
                                  leading: const Icon(Icons.bookmark, color: AppColors.primary, size: 20),
                                  title: Text(dir.etiqueta ?? 'Dirección',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  subtitle: Text('${dir.direccion ?? ''}, ${dir.distrito ?? ''}',
                                      style: const TextStyle(fontSize: 12)),
                                  dense: true,
                                  onTap: () => _seleccionarDireccion(dir),
                                )),
                          ],
                          if (_buscando)
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                ),
                              ),
                            )
                          else if (_resultadosNominatim.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                              child: Text('Lugares encontrados',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            ..._resultadosNominatim.map((r) => ListTile(
                                  leading: const Icon(Icons.location_on, color: AppColors.textGrey, size: 20),
                                  title: Text(r['display_name'] ?? '', style: const TextStyle(fontSize: 13)),
                                  dense: true,
                                  onTap: () => _seleccionarResultadoNominatim(r),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 220,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _marcador,
                          initialZoom: 15,
                          onTap: _modoPersonalizado
                              ? (_, point) => setState(() => _marcador = point)
                              : null,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.homefix.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _marcador,
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_modoPersonalizado)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: const [
                          Icon(Icons.touch_app, color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text('Toca el mapa para mover el marcador',
                              style: TextStyle(color: AppColors.primary, fontSize: 13)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  const Text('Mis direcciones',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),

                  if (_cargando)
                    const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  else if (_direcciones.isEmpty)
                    Text('No tienes direcciones guardadas.', style: TextStyle(color: Colors.grey[500]))
                  else
                    ..._direcciones.map((dir) {
                      final seleccionada = _seleccionada?.id == dir.id;
                      return GestureDetector(
                        onTap: () => _seleccionarDireccion(dir),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: seleccionada ? const Color(0xFFFFF5F0) : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: seleccionada ? AppColors.primary : Colors.grey[300]!,
                              width: seleccionada ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                dir.etiqueta?.toLowerCase() == 'casa'
                                    ? Icons.home
                                    : dir.etiqueta?.toLowerCase() == 'trabajo'
                                        ? Icons.work
                                        : Icons.location_on,
                                color: seleccionada ? AppColors.primary : AppColors.textGrey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dir.etiqueta ?? 'Dirección',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: seleccionada ? AppColors.primary : AppColors.textDark,
                                          ),
                                        ),
                                        if (dir.esPredeterminada) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('Principal',
                                                style: TextStyle(color: AppColors.primary, fontSize: 11)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${dir.direccion ?? ''}, ${dir.distrito ?? ''}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              if (seleccionada)
                                const Icon(Icons.check_circle, color: AppColors.primary),
                            ],
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _activarModoPersonalizado,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _modoPersonalizado ? const Color(0xFFFFF5F0) : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _modoPersonalizado ? AppColors.primary : Colors.grey[300]!,
                          width: _modoPersonalizado ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_location_alt,
                              color: _modoPersonalizado ? AppColors.primary : AppColors.textGrey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Usar otra ubicación',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _modoPersonalizado ? AppColors.primary : AppColors.textDark,
                              ),
                            ),
                          ),
                          if (_modoPersonalizado)
                            const Icon(Icons.check_circle, color: AppColors.primary),
                        ],
                      ),
                    ),
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
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: puedeContinar ? _continuar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}