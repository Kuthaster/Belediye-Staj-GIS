import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/screens/object_detail_screen.dart';
import 'package:frontend/widgets/type_picker_bottom_sheet.dart';

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
            return const Center(child: Text('Henüz kaydedilen bir cisim yok.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(urbanObjectListProvider),
            child: ListView.builder(
              itemCount: objects.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: const Text("+"),
                    subtitle: const Text("Yeni Cisim Oluştur"),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const TypePickerBottomSheet(),
                      );
                    },
                  );
                }
                final obj = objects[index - 1];
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
