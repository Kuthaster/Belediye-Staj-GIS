import 'package:flutter/material.dart';

class EditableDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const EditableDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(
        value == null ? '-' : value!.toLocal().toString().split(' ').first,
      ),
      trailing: const Icon(Icons.calendar_today, size: 18),
      onTap: () => _pickDate(context),
    );
  }
}
