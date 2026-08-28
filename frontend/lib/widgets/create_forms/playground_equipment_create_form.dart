import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/models/enum/age_group.dart';
import 'package:frontend/models/enum/equipment_type.dart';
import 'package:frontend/providers/controller/playground_equipment_create_provider.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/widgets/location_picker_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/services/error_interceptor.dart';

class PlaygroundEquipmentCreateForm extends ConsumerStatefulWidget {
  final LatLng? location;
  final ScrollController scrollController;

  const PlaygroundEquipmentCreateForm({
    super.key,
    required this.location,
    required this.scrollController,
  });

  @override
  ConsumerState<PlaygroundEquipmentCreateForm> createState() =>
      _PlaygroundEquipmentCreateFormState();
}

class _PlaygroundEquipmentCreateFormState
    extends ConsumerState<PlaygroundEquipmentCreateForm> {
  LatLng? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
  }

  final _formKey = GlobalKey<FormState>();
  EquipmentType? _equipmentType;
  AgeGroup? _ageGroup;
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
    setState(() => _safetyCertificationDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_location == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir konum seçin.')));
      return;
    }

    final dto = PlaygroundEquipmentCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      safetyCertificationDate: _safetyCertificationDate,

      equipmentType: _equipmentType!,
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
    ref.invalidate(urbanObjectListProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playGroundEquipmentControllerProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.location == null)
            LocationPickerButton(
              value: _location,
              onChanged: (loc) => setState(() => _location = loc),
            )
          else
            Text('Konum: ${_location!.latitude}, ${_location!.longitude}'),

          DropdownButtonFormField<EquipmentType>(
            initialValue: _equipmentType,
            decoration: const InputDecoration(
              labelText: 'Ekipman tipi',
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
                return 'Ekipman tipi seçiniz';
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
    );
  }
}
