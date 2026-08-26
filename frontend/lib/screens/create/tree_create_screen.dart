import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/widgets/location_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/models/create/tree_create.dart';
import 'package:frontend/providers/controller/tree_create_controller.dart';
import 'package:frontend/services/error_interceptor.dart';

class TreeCreateScreen extends ConsumerStatefulWidget {
  const TreeCreateScreen({super.key});

  @override
  ConsumerState<TreeCreateScreen> createState() => _TreeCreateScreenState();
}

class _TreeCreateScreenState extends ConsumerState<TreeCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _speciesController = TextEditingController();
  final _trunkDiameterController = TextEditingController();
  final _heightController = TextEditingController();
  final _healthStatusController = TextEditingController();

  LatLng? _location;
  DateTime? _plantingDate;

  @override
  void dispose() {
    _speciesController.dispose();
    _trunkDiameterController.dispose();
    _heightController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  Future<void> _pickPlantingDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _plantingDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_location == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen konum seçin.')));
      return;
    }

    final dto = TreeCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      species: _speciesController.text.isEmpty ? null : _speciesController.text,
      trunkDiameterCm: _trunkDiameterController.text.isEmpty
          ? null
          : double.tryParse(_trunkDiameterController.text),
      plantingDate: _plantingDate,
      heightM: _heightController.text.isEmpty
          ? null
          : double.tryParse(_heightController.text),
      healthStatus: _healthStatusController.text.isEmpty
          ? null
          : _healthStatusController.text,
    );

    await ref.read(treeCreateControllerProvider.notifier).submit(dto);

    final state = ref.read(treeCreateControllerProvider);

    if (state.hasError) {
      final error = state.error;
      final message = error is AppException
          ? error.message
          : 'Bir şeyler ters gitti.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
      return;
    }
    ref.invalidate(urbanObjectListProvider);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treeCreateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ağaç ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LocationPicker(
              value: _location,
              onChanged: (newLocation) =>
                  setState(() => _location = newLocation),
            ),
            Text(
              _location == null
                  ? 'Konum seçilmedi'
                  : 'Konum: ${_location!.latitude}, ${_location!.longitude}',
            ),

            TextFormField(
              controller: _speciesController,
              decoration: const InputDecoration(labelText: 'Tür'),
            ),
            TextFormField(
              controller: _trunkDiameterController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Gövde çapı (cm)'),
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                if (double.tryParse(value) == null) {
                  return 'Geçerli bir sayı girin.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Yükseklik (m)'),
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                if (double.tryParse(value) == null) {
                  return 'Geçerli bir sayı girin.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _healthStatusController,
              decoration: const InputDecoration(labelText: 'Sağlık durumu'),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _plantingDate == null
                    ? 'Dikilme tarihi belirtilmedi'
                    : 'Dikilme tarihi: ${_plantingDate!.toLocal().toString().split(' ').first}',
              ),
              trailing: const Icon(Icons.calendar_month_sharp),
              onTap: _pickPlantingDate,
            ),

            const SizedBox(height: 16),

            if (state.isLoading) const CircularProgressIndicator(),

            ElevatedButton(
              onPressed: state.isLoading ? null : _submit,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
