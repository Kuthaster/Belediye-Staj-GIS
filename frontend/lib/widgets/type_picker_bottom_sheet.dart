import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/screens/create/bench_create_screen.dart';

class TypePickerBottomSheet extends ConsumerWidget {
  const TypePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: ObjectType.values.map((type) {
        return ListTile(
          title: Text(type.displayName),
          onTap: () async {
            Navigator.pop(context);

            switch (type) {
              case ObjectType.bench:
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BenchCreateScreen()),
                );
                break;
              case ObjectType.trashBin:
                // TODO: TrashBinCreateScreen yazılınca ekle
                break;
              case ObjectType.tree:
                // TODO: TreeCreateScreen yazılınca ekle
                break;
              case ObjectType.lightingPole:
                // TODO: LightingPoleCreateScreen yazılınca ekle
                break;
              case ObjectType.playgroundEquipment:
                // TODO: PlaygroundEquipmentCreateScreen yazılınca ekle
                break;
            }

            ref.invalidate(urbanObjectListProvider);
          },
        );
      }).toList(),
    );
  }
}
