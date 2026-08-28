import 'package:flutter/material.dart';
import 'package:frontend/models/enum/object_status.dart';

class StatusDisplayChip extends StatelessWidget {
  final ObjectStatus value;

  const StatusDisplayChip({super.key, required this.value});

  Color _colorFor(ObjectStatus status) {
    switch (status) {
      case ObjectStatus.active:
        return Colors.green; //RENK
      case ObjectStatus.needsMaintenance:
        return Colors.orange;
      case ObjectStatus.broken:
        return Colors.red;
      case ObjectStatus.removed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Durum'),
      trailing: Chip(
        label: Text(
          value.displayName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _colorFor(value),
      ),
    );
  }
}
