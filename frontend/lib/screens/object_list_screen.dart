import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';
import 'package:frontend/widgets/display/object_detail_sheet.dart';
import 'package:frontend/widgets/account/profile_drawer.dart';
import 'package:frontend/widgets/create/create_object_tile.dart';

class ObjectListScreen extends ConsumerWidget {
  const ObjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectsAsync = ref.watch(urbanObjectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cisimler')),
      endDrawer: ProfileDrawer(),

      body: objectsAsync.when(
        data: (objects) {
          if (objects.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Henüz kaydedilen bir cisim yok. Cisim oluşturarak başla.',
                    ),
                  ),
                  const CreateObjectTile(),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(urbanObjectListProvider),
            child: ListView.builder(
              itemCount: objects.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const CreateObjectTile();
                }
                final obj = objects[index - 1];
                return ListTile(
                  title: Text(obj.type.displayName),
                  subtitle: Text('Durum: ${obj.status.displayName}'),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ObjectDetailSheet(id: obj.id),
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
