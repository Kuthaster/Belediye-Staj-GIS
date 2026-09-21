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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final text = _controller.text;
    widget.onChanged(text.isEmpty ? null : text);
    setState(() => _isEditing = false);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _commit();
    }
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return ListTile(
        title: Text(widget.label),
        subtitle: Text(widget.value ?? '-'),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: _startEditing,
      );
    }

    return ListTile(
      title: Text(widget.label),
      subtitle: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        onSubmitted: (_) => _commit(),
      ),
      trailing: IconButton(icon: const Icon(Icons.check), onPressed: _commit),
    );
  }
}
