import 'package:flutter/material.dart';

class EditableBoolField extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const EditableBoolField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}
