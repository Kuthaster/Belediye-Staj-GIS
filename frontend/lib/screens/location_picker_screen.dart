import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  LatLng? _picked;
  bool _isLocating = false;

  static const _fallbackCenter = LatLng(41.28, 36.33);

  @override
  void initState() {
    super.initState();
    _picked = widget.initialLocation;
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Konum servisleri kapalı.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Konum izni verilmedi.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Konum izni kalıcı olarak kapalı. Ayarlar menüsünden aktifleştirebilirsiniz.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          forceLocationManager: true,
        ), // forceLocaitonManager GOOGLE yerine yerel Konum yöneticisi zorluyor.
      );

      setState(() => _picked = LatLng(position.latitude, position.longitude));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() => _picked = point);
  }

  @override
  Widget build(BuildContext context) {
    final objectsAsync = ref.watch(urbanObjectListProvider);
    final dataFallback = objectsAsync.maybeWhen(
      data: (objects) => objects.isNotEmpty
          ? LatLng(objects.first.latitude, objects.first.longitude)
          : _fallbackCenter,
      orElse: () => _fallbackCenter,
    );
    final center = _picked ?? widget.initialLocation ?? dataFallback;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum Seç'),
        actions: [
          TextButton(
            onPressed: _picked == null
                ? null
                : () => Navigator.pop(context, _picked),
            child: const Text('Onayla'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kutalmis.cografi_nesne_takip',
              ),
              if (_picked != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _picked!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ), //RENK
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isLocating ? null : _useCurrentLocation,
              child: _isLocating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
