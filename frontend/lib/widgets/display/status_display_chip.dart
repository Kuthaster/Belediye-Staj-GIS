import 'package:flutter/material.dart';
import 'package:frontend/models/enum/object_status.dart';

class StatusDisplayChip extends StatelessWidget {
  final ObjectStatus value;
  final bool isUpdating;
  final ValueChanged<ObjectStatus>? onChanged;

  const StatusDisplayChip({
    super.key,
    required this.value,
    this.onChanged,
    this.isUpdating = false,
  });

  Color _colorFor(ObjectStatus status) {
    switch (status) {
      case ObjectStatus.active:
        return Colors.green;
      case ObjectStatus.needsMaintenance:
        return Colors.orange;
      case ObjectStatus.broken:
        return Colors.red;
      case ObjectStatus.removed:
        return Colors.grey;
    }
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<ObjectStatus>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ObjectStatus.values.map((status) {
            return ListTile(
              leading: CircleAvatar(
                radius: 8,
                backgroundColor: _colorFor(status),
              ),
              title: Text(status.displayName),
              trailing: status == value ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, status),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && selected != value) {
      onChanged!(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editable = onChanged != null;

    final chip = Chip(
      label: Text(
        value.displayName,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: _colorFor(value),
      avatar: editable
          ? const Icon(Icons.edit, size: 14, color: Colors.white70)
          : null,
    );

    return ListTile(
      title: const Text('Durum'),
      trailing: isUpdating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : editable
          ? InkWell(
              onTap: () => _openPicker(context),
              borderRadius: BorderRadius.circular(16),
              child: chip,
            )
          : chip,
    );
  }
}
