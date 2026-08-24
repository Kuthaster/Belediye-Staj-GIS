import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/models/enum/age_group.dart';
import 'package:frontend/models/enum/equipment_type.dart';
import 'package:frontend/providers/controller/playground_equipment_create_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/services/error_interceptor.dart';

class PlaygroundEquipmentCreateScreen extends ConsumerStatefulWidget {
  const PlaygroundEquipmentCreateScreen({super.key});

  @override
  ConsumerState<PlaygroundEquipmentCreateScreen> createState() =>
      _PlaygroundEquipmentCreateScreenState();
}

class _PlaygroundEquipmentCreateScreenState
    extends ConsumerState<PlaygroundEquipmentCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  LatLng? _location;
  EquipmentType _equipmentType = EquipmentType.slide;
  AgeGroup _ageGroup = AgeGroup.allAges;
  DateTime? _safetyCertificationDate;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickSafetyCertificationDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _safetyCertificationDate = picked);
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

    final dto = PlaygroundEquipmentCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      safetyCertificationDate: _safetyCertificationDate,

      eqiupmentType: _equipmentType,
      ageGroup: _ageGroup,
    );

    await ref.read(playGroundEquipmentControllerProvider.notifier).submit(dto);

    final state = ref.read(playGroundEquipmentControllerProvider);

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

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playGroundEquipmentControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Oyun alanı ekipmanı ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // TODO: Location Picker yazılınca ekle
            Text(
              _location == null
                  ? 'Konum seçilmedi'
                  : 'Konum: ${_location!.latitude}, ${_location!.longitude}',
            ),

            DropdownButtonFormField<EquipmentType>(
              initialValue: _equipmentType,
              decoration: const InputDecoration(
                labelText: 'Ekipman türü',
                border: OutlineInputBorder(),
              ),
              items: EquipmentType.values.map((equipmentType) {
                return DropdownMenuItem<EquipmentType>(
                  value: equipmentType,
                  child: Text(equipmentType.displayName),
                );
              }).toList(),
              onChanged: (EquipmentType? value) {
                if (value != null) {
                  setState(() {
                    _equipmentType = value;
                  });
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Ekipman türü seçiniz';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<AgeGroup>(
              initialValue: _ageGroup,
              decoration: const InputDecoration(
                labelText: 'Yaş aralığı',
                border: OutlineInputBorder(),
              ),
              items: AgeGroup.values.map((ageGroup) {
                return DropdownMenuItem<AgeGroup>(
                  value: ageGroup,
                  child: Text(ageGroup.displayName),
                );
              }).toList(),
              onChanged: (AgeGroup? value) {
                if (value != null) {
                  setState(() {
                    _ageGroup = value;
                  });
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Yaş aralığı seçiniz';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _safetyCertificationDate == null
                    ? 'Güvenlik sertifikası verilme tarihi belirtilmedi'
                    : 'Güvenlik sertifikası verilme tarihi: ${_safetyCertificationDate!.toLocal().toString().split(' ').first}',
              ),
              trailing: const Icon(Icons.calendar_month_sharp),
              onTap: _pickSafetyCertificationDate,
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
