import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/screens/object_detail_sheet.dart';
import 'package:frontend/widgets/create_object_sheet.dart';

class ObjectMapScreen extends ConsumerStatefulWidget {
  const ObjectMapScreen({super.key});

  @override
  ConsumerState<ObjectMapScreen> createState() => _ObjectMapScreenState();
}

class _ObjectMapScreenState extends ConsumerState<ObjectMapScreen> {
  LatLng? _pendingCreateLocation;

  void _onMapLongPress(TapPosition position, LatLng point) {
    setState(() => _pendingCreateLocation = point);
    _openCreateSheet(point);
  }

  Future<void> _openCreateSheet(LatLng point) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateObjectSheet(location: point),
    );
    if (mounted) {
      setState(() => _pendingCreateLocation = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final objectsAsync = ref.watch(urbanObjectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cisim Haritası')),
      body: objectsAsync.when(
        data: (objects) {
          final markers = objects.map((obj) {
            return Marker(
              point: LatLng(obj.latitude, obj.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => ObjectDetailSheet(id: obj.id),
                  );
                },
                child: const Icon(
                  Icons.location_pin,
                  size: 36,
                  color: Colors.red,
                ),
              ),
            );
          }).toList();

          if (_pendingCreateLocation != null) {
            markers.add(
              Marker(
                point: _pendingCreateLocation!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.add_location,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            );
          }

          final center = objects.isNotEmpty
              ? LatLng(objects.first.latitude, objects.first.longitude)
              : const LatLng(41.28, 36.33);

          return FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 14,
              onLongPress: _onMapLongPress,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kutalmis.cografi_nesne_takip',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Yüklenemedi: $err')),
      ),
    );
  }
}
