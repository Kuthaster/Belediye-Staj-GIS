import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/screens/object_detail_screen.dart';

class ObjectListScreen extends ConsumerWidget {
  const ObjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectsAsync = ref.watch(urbanObjectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cisimler')),
      body: objectsAsync.when(
        data: (objects) {
          if (objects.isEmpty) {
            return const Center(child: Text('Hanüz kaydedilen bir cisim yok.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(urbanObjectListProvider),
            child: ListView.builder(
              itemCount: objects.length,
              itemBuilder: (context, index) {
                final obj = objects[index];
                return ListTile(
                  title: Text(obj.type.displayName),
                  subtitle: Text('Status: ${obj.status.displayName}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ObjectDetailScreen(id: obj.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Yüklenemedi: $err')),
      ),
    );
  }
}
