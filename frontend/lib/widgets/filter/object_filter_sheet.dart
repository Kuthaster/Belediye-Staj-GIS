import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';
import 'package:frontend/models/filter/object_filter.dart';

class ObjectFilterSheet extends ConsumerStatefulWidget {
  const ObjectFilterSheet({super.key});

  @override
  ConsumerState<ObjectFilterSheet> createState() => _ObjectFilterSheetState();
}

class _ObjectFilterSheetState extends ConsumerState<ObjectFilterSheet> {
  late ObjectType? _type;
  late ObjectStatus? _status;
  late DateTime? _from;
  late DateTime? _to;

  @override
  void initState() {
    super.initState();
    final current = ref.read(objectFilterProvider);
    _type = current.type;
    _status = current.status;
    _from = current.createdFrom;
    _to = current.createdTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  void _apply() {
    ref.read(objectFilterProvider.notifier).state = ObjectFilter(
      type: _type,
      status: _status,
      createdFrom: _from,
      createdTo: _to,
    );
    Navigator.pop(context);
  }

  void _clear() {
    ref.read(objectFilterProvider.notifier).state = const ObjectFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filtrele',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ObjectType>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Tür',
                border: OutlineInputBorder(),
              ),
              items: ObjectType.values
                  .map(
                    (t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ObjectStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Durum',
                border: OutlineInputBorder(),
              ),
              items: ObjectStatus.values
                  .map(
                    (s) =>
                        DropdownMenuItem(value: s, child: Text(s.displayName)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _status = v),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _from == null
                    ? 'Başlangıç tarihi seçilmedi'
                    : 'Başlangıç: ${_from!.toLocal().toString().split(' ').first}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () => _pickDate(isFrom: true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _to == null
                    ? 'Bitiş tarihi seçilmedi'
                    : 'Bitiş: ${_to!.toLocal().toString().split(' ').first}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () => _pickDate(isFrom: false),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    child: const Text('Temizle'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const Text('Uygula'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
