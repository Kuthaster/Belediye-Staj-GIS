import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/models/enum/bin_type.dart';
import 'package:frontend/providers/controller/trash_bin_create_controller.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/widgets/location_picker_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/providers/controller/tree_create_controller.dart';
import 'package:frontend/services/error_interceptor.dart';

class TrashBinCreateScreen extends ConsumerStatefulWidget {
  const TrashBinCreateScreen({super.key});

  @override
  ConsumerState<TrashBinCreateScreen> createState() =>
      _TrashBinCreateScreenState();
}

class _TrashBinCreateScreenState extends ConsumerState<TrashBinCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _volumeLitersController = TextEditingController();
  final _trunkDiameterController = TextEditingController();
  final _materialController = TextEditingController();
  final _collectionFrequencyDays = TextEditingController();

  LatLng? _location;
  BinType? _binType;

  @override
  void dispose() {
    _volumeLitersController.dispose();
    _trunkDiameterController.dispose();
    _materialController.dispose();
    _collectionFrequencyDays.dispose();
    super.dispose();
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

    final dto = TrashBinCreate(
      latitude: _location!.latitude,
      longitude: _location!.longitude,
      volumeLiters: _volumeLitersController.text.isEmpty
          ? null
          : double.tryParse(_volumeLitersController.text),
      binType:
          _binType!, //TODO BÖYLE DEFAULT DEĞERSİZ YAPMAYI DENE DAHA İYİYSE ÖBÜRLERİNİ BUNA GEÇİR
      material: _materialController.text.isEmpty
          ? null
          : _materialController.text,
      collectionFrequencyDays: _collectionFrequencyDays.text.isEmpty
          ? null
          : int.tryParse(_trunkDiameterController.text),
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
    ref.invalidate(urbanObjectListProvider);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treeCreateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Çöp kutusu ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LocationPickerButton(
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
              controller: _volumeLitersController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
              controller: _collectionFrequencyDays,
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
