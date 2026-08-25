import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  final LatLng? value;
  final ValueChanged<LatLng> onChanged;

  const LocationPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool _isLocating = false;
  String? _error;

  static const _fallbackCenter = LatLng(40.54889, 34.95333); //ÇORUM

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Konum servisleri kapalı.');
      }

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

      final newLocation = LatLng(position.latitude, position.longitude);
      widget.onChanged(newLocation);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    widget.onChanged(point);
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.value ?? _fallbackCenter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.value == null
                    ? 'Konum Seçilmedi'
                    : 'Konum: ${widget.value!.latitude.toStringAsFixed(5)}, ${widget.value!.longitude.toStringAsFixed(5)}',
              ),
            ),
            TextButton.icon(
              onPressed: _isLocating ? null : _useCurrentLocation,
              icon: _isLocating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: const Text('Konumumu kullan.'),
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        const Text(
          'Haritaya tıklayarak manüel konum seçebilirsiniz:',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: FlutterMap(
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
              if (widget.value != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.value!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 36,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
