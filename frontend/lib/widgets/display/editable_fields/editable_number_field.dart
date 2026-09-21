import 'package:flutter/material.dart';

class EditableNumberField extends StatefulWidget {
  final String label;
  final num? value;
  final bool isInt;
  final ValueChanged<num?> onChanged;

  const EditableNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isInt = false,
  });

  @override
  State<EditableNumberField> createState() => _EditableNumberFieldState();
}

class _EditableNumberFieldState extends State<EditableNumberField> {
  bool _isEditing = false;
  late TextEditingController _controller;
  String? _error;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
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
    if (text.isEmpty) {
      widget.onChanged(null);
      setState(() {
        _isEditing = false;
        _error = null;
      });
      return;
    }

    final parsed = widget.isInt ? int.tryParse(text) : double.tryParse(text);
    if (parsed == null) {
      setState(() => _error = 'Geçersiz sayı');
      return;
    }

    widget.onChanged(parsed);
    setState(() {
      _isEditing = false;
      _error = null;
    });
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
        subtitle: Text(widget.value?.toString() ?? '-'),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: _startEditing,
      );
    }

    return ListTile(
      title: Text(widget.label),
      subtitle: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(decimal: !widget.isInt),
        onSubmitted: (_) => _commit(),
        decoration: InputDecoration(errorText: _error),
      ),
      trailing: IconButton(icon: const Icon(Icons.check), onPressed: _commit),
    );
  }
}
