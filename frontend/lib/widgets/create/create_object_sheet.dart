import 'package:flutter/material.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/widgets/create/create_forms/bench_create_form.dart';
import 'package:frontend/widgets/create/create_forms/trash_bin_create_form.dart';
import 'package:frontend/widgets/create/create_forms/lighting_pole_create_form.dart';
import 'package:frontend/widgets/create/create_forms/playground_equipment_create_form.dart';
import 'package:frontend/widgets/create/create_forms/tree_create_form.dart';
import 'package:latlong2/latlong.dart';

class CreateObjectSheet extends StatefulWidget {
  final LatLng? location;
  const CreateObjectSheet({super.key, this.location});

  @override
  State<CreateObjectSheet> createState() => _CreateObjectSheetState();
}

class _CreateObjectSheetState extends State<CreateObjectSheet> {
  ObjectType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: _selectedType == null
              ? _buildTypeList()
              : _buildCreateForm(_selectedType!, scrollController),
        );
      },
    );
  }

  Widget _buildTypeList() {
    return ListView(
      children: ObjectType.values.map((type) {
        return ListTile(
          title: Text(type.displayName),
          onTap: () => setState(() => _selectedType = type),
        );
      }).toList(),
    );
  }

  Widget _buildCreateForm(ObjectType type, ScrollController scrollController) {
    switch (type) {
      case ObjectType.bench:
        return BenchCreateForm(
          location: widget.location,
          scrollController: scrollController,
        );
      case ObjectType.trashBin:
        return TrashBinCreateForm(
          location: widget.location,
          scrollController: scrollController,
        );
      case ObjectType.tree:
        return TreeCreateForm(
          location: widget.location,
          scrollController: scrollController,
        );
      case ObjectType.lightingPole:
        return LightingPoleCreateForm(
          location: widget.location,
          scrollController: scrollController,
        );
      case ObjectType.playgroundEquipment:
        return PlaygroundEquipmentCreateForm(
          location: widget.location,
          scrollController: scrollController,
        );
    }
  }
}
