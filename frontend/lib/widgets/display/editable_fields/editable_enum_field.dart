import 'package:flutter/material.dart';

class EditableEnumField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) displayName;
  final ValueChanged<T?> onChanged;

  const EditableEnumField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.displayName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<T>(
        value: value,
        hint: const Text('-'),
        items: options.map((option) {
          return DropdownMenuItem<T>(
            value: option,
            child: Text(displayName(option)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
