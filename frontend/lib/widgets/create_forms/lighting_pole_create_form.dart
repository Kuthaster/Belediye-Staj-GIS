import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/lighting_pole_create.dart';
import 'package:frontend/models/enum/light_type.dart';
import 'package:frontend/models/enum/power_source.dart';
import 'package:frontend/providers/controller/lighting_pole_create_controller.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/widgets/location_picker_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/services/error_interceptor.dart';

class LightingPoleCreateForm extends ConsumerStatefulWidget {
  final LatLng? location;
  final ScrollController scrollController;

  const LightingPoleCreateForm({
    super.key,
    required this.location,
    required this.scrollController,
  });

  @override
  ConsumerState<LightingPoleCreateForm> createState() =>
      _LightingPoleCreateFormState();
}

class _LightingPoleCreateFormState
    extends ConsumerState<LightingPoleCreateForm> {
  LatLng? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
  }

  final _formKey = GlobalKey<FormState>();
  final _wattageController = TextEditingController();
  final _heightController = TextEditingController();

  LightType _lightType = LightType.led;
  PowerSource _powerSource = PowerSource.grid;

  @override
  void dispose() {
    _wattageController.dispose();
    _heightController.dispose();
    super.dispose();
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

    final dto = LightingPoleCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      wattage: _wattageController.text.isEmpty
          ? null
          : int.tryParse(_wattageController.text),
      heightM: _heightController.text.isEmpty
          ? null
          : double.tryParse(_heightController.text),
      lightType: _lightType,
      powerSource: _powerSource,
    );

    await ref.read(lightingPoleCreateControllerProvider.notifier).submit(dto);
    final state = ref.read(lightingPoleCreateControllerProvider);

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
    final state = ref.watch(lightingPoleCreateControllerProvider);

    return Form(
      key: _formKey,
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.location == null)
            LocationPickerButton(
              value: _location,
              onChanged: (loc) => setState(() => _location = loc),
            )
          else
            Text('Konum: ${_location!.latitude}, ${_location!.longitude}'),

          TextFormField(
            controller: _wattageController,
            decoration: const InputDecoration(labelText: 'Watt'),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null) {
                return 'Geçerli bir sayı girin.';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Yükseklik (m)'),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (double.tryParse(value) == null) {
                return 'Geçerli bir sayı girin.';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<LightType>(
            initialValue: _lightType,
            decoration: const InputDecoration(
              labelText: 'Aydınlatma tipi',
              border: OutlineInputBorder(),
            ),
            items: LightType.values.map((lightType) {
              return DropdownMenuItem<LightType>(
                value: lightType,
                child: Text(lightType.displayName),
              );
            }).toList(),
            onChanged: (LightType? value) {
              if (value != null) {
                setState(() {
                  _lightType = value;
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Aydınlatma tipi seçiniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          DropdownButtonFormField<PowerSource>(
            initialValue: _powerSource,
            decoration: const InputDecoration(
              labelText: 'Güç kaynağı',
              border: OutlineInputBorder(),
            ),
            items: PowerSource.values.map((powerSource) {
              return DropdownMenuItem<PowerSource>(
                value: powerSource,
                child: Text(powerSource.displayName),
              );
            }).toList(),
            onChanged: (PowerSource? value) {
              if (value != null) {
                setState(() {
                  _powerSource = value;
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Güç kaynağı seçiniz';
              }
              return null;
            },
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
