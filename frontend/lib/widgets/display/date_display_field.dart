import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplayField extends StatelessWidget {
  final DateTime? date;
  final String label;

  const DateDisplayField({super.key, this.date, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(
        date == null
            ? '-'
            : DateFormat('dd.MM.yyyy HH:mm').format(date!.toLocal()),
      ),
    );
  }
}
