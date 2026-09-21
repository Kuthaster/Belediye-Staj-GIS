import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/models/enum/bin_type.dart';
import 'package:frontend/providers/controller/trash_bin_create_controller.dart';
import 'package:frontend/providers/object/photo_providers.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';
import 'package:frontend/widgets/create/location_picker_button.dart';
import 'package:frontend/widgets/create/photo_picker_field.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/services/error_interceptor.dart';

class TrashBinCreateForm extends ConsumerStatefulWidget {
  final LatLng? location;
  final ScrollController scrollController;

  const TrashBinCreateForm({
    super.key,
    required this.location,
    required this.scrollController,
  });

  @override
  ConsumerState<TrashBinCreateForm> createState() => _TrashBinCreateFormState();
}

class _TrashBinCreateFormState extends ConsumerState<TrashBinCreateForm> {
  LatLng? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
  }

  final _formKey = GlobalKey<FormState>();
  final _volumeLitersController = TextEditingController();
  final _materialController = TextEditingController();
  final _collectionFrequencyDaysController = TextEditingController();
  File? _photo;
  bool _isUploadingPhoto = false;
  BinType? _binType;

  @override
  void dispose() {
    _volumeLitersController.dispose();
    _materialController.dispose();
    _collectionFrequencyDaysController.dispose();
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

    final dto = TrashBinCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      volumeLiters: _volumeLitersController.text.isEmpty
          ? null
          : double.tryParse(_volumeLitersController.text),
      binType: _binType!,
      material: _materialController.text.isEmpty
          ? null
          : _materialController.text,
      collectionFrequencyDays: _collectionFrequencyDaysController.text.isEmpty
          ? null
          : int.tryParse(_collectionFrequencyDaysController.text),
    );

    await ref.read(trashBinCreateControllerProvider.notifier).submit(dto);
    final state = ref.read(trashBinCreateControllerProvider);

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
    final state = ref.watch(trashBinCreateControllerProvider);
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
            controller: _volumeLitersController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Hacim (L)'),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (double.tryParse(value) == null) {
                return 'Geçerli bir sayı girin.';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _materialController,
            decoration: const InputDecoration(labelText: 'Materyal'),
          ),

          TextFormField(
            controller: _collectionFrequencyDaysController,
            decoration: const InputDecoration(
              labelText: 'Toplama sıklığı (gün)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null) {
                return 'Geçerli bir sayı girin.';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<BinType>(
            initialValue: _binType,
            decoration: const InputDecoration(
              labelText: 'Çöp kutusu tipi',
              border: OutlineInputBorder(),
            ),
            items: BinType.values.map((binType) {
              return DropdownMenuItem<BinType>(
                value: binType,
                child: Text(binType.displayName),
              );
            }).toList(),
            onChanged: (BinType? value) {
              if (value != null) {
                setState(() {
                  _binType = value;
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Çöp kutusu tipi seçiniz';
              }
              return null;
            },
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
