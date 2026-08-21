// lib/screens/object_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/screens/object_detail_screen.dart';

class ObjectMapScreen extends ConsumerWidget {
  const ObjectMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ObjectDetailScreen(id: obj.id),
                    ),
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

          final center = objects.isNotEmpty
              ? LatLng(objects.first.latitude, objects.first.longitude)
              : const LatLng(41.28, 36.33); // fallback center

          return FlutterMap(
            options: MapOptions(initialCenter: center, initialZoom: 14),
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
