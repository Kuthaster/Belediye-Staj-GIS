import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const EditableTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final text = _controller.text;
    widget.onChanged(text.isEmpty ? null : text);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return ListTile(
        title: Text(widget.label),
        subtitle: Text(widget.value ?? '-'),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: () => setState(() => _isEditing = true),
      );
    }

    return ListTile(
      title: Text(widget.label),
      subtitle: TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (_) => _commit(),
      ),
      trailing: IconButton(icon: const Icon(Icons.check), onPressed: _commit),
    );
  }
}
