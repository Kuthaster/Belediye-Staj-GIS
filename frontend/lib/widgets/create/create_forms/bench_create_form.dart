import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/providers/controller/bench_create_controller.dart';
import 'package:frontend/providers/object/photo_providers.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';
import 'package:frontend/services/error_interceptor.dart';
import 'package:frontend/widgets/create/location_picker_button.dart';
import 'package:frontend/widgets/create/photo_picker_field.dart';
import 'package:latlong2/latlong.dart';

class BenchCreateForm extends ConsumerStatefulWidget {
  final LatLng? location;
  final ScrollController scrollController;

  const BenchCreateForm({
    super.key,
    this.location,
    required this.scrollController,
  });

  @override
  ConsumerState<BenchCreateForm> createState() => _BenchCreateFormState();
}

class _BenchCreateFormState extends ConsumerState<BenchCreateForm> {
  LatLng? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
  }

  final _formKey = GlobalKey<FormState>();
  final _seatCountController = TextEditingController();
  final _materialController = TextEditingController();
  bool _hasBackrest = false;
  File? _photo;
  bool _isUploadingPhoto = false;

  @override
  void dispose() {
    _seatCountController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_location == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir konum seçin.')));
      return;
    }

    final dto = BenchCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      seatCount: int.parse(_seatCountController.text),
      material: _materialController.text.isEmpty
          ? null
          : _materialController.text,
      hasBackrest: _hasBackrest,
    );

    await ref.read(benchCreateControllerProvider.notifier).submit(dto);
    final state = ref.read(benchCreateControllerProvider);

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

    final created = state.value;

    if (_photo != null && created != null) {
      setState(() => _isUploadingPhoto = true);
      try {
        final photoService = ref.read(photoServiceProvider);
        await photoService.uploadPhoto(created.id, _photo!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cisim oluşturuldu, ancak fotoğraf yüklenemedi.'),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isUploadingPhoto = false);
      }
    }

    ref.invalidate(urbanObjectListProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(benchCreateControllerProvider);
    final isBusy = state.isLoading || _isUploadingPhoto;
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
            controller: _seatCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Koltuk Sayısı'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş bırakılamaz';
              }
              if (int.tryParse(value) == null) {
                return 'Geçerli bir sayı girin';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _materialController,
            decoration: const InputDecoration(labelText: 'Materyal'),
          ),
          SwitchListTile(
            title: const Text('Sırtlığı Var'),
            value: _hasBackrest,
            onChanged: (v) => setState(() => _hasBackrest = v),
          ),
          const SizedBox(height: 16),
          PhotoPickerField(
            value: _photo,
            onChanged: (file) => setState(() => _photo = file),
          ),
          const SizedBox(height: 16),
          if (isBusy) const CircularProgressIndicator(),
          ElevatedButton(
            onPressed: isBusy ? null : _submit,
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
