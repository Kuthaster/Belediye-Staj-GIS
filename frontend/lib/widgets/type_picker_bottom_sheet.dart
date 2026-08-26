import 'package:flutter/material.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/screens/create/bench_create_screen.dart';
import 'package:frontend/screens/create/trash_bin_create_screen.dart';
import 'package:frontend/screens/create/tree_create_screen.dart';
import 'package:frontend/screens/create/lighting_pole_create_screen.dart';
import 'package:frontend/screens/create/playground_equipment_create_screen.dart';

class TypePickerBottomSheet extends StatelessWidget {
  const TypePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: ObjectType.values.map((type) {
        return ListTile(
          title: Text(type.displayName),
          onTap: () {
            Navigator.pop(context);

            switch (type) {
              case ObjectType.bench:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BenchCreateScreen()),
                );
                break;
              case ObjectType.trashBin:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrashBinCreateScreen(),
                  ),
                );
                break;
              case ObjectType.tree:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TreeCreateScreen()),
                );
                break;
              case ObjectType.lightingPole:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LightingPoleCreateScreen(),
                  ),
                );
                break;
              case ObjectType.playgroundEquipment:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaygroundEquipmentCreateScreen(),
                  ),
                );
                break;
            }
          },
        );
      }).toList(),
    );
  }
}
