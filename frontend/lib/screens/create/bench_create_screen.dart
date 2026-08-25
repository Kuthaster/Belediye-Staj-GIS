import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/providers/controller/bench_create_controller.dart';
import 'package:frontend/services/error_interceptor.dart';
import 'package:frontend/widgets/location_picker.dart';
import 'package:latlong2/latlong.dart';

class BenchCreateScreen extends ConsumerStatefulWidget {
  const BenchCreateScreen({super.key});

  @override
  ConsumerState<BenchCreateScreen> createState() => _BenchCreateScreenState();
}

class _BenchCreateScreenState extends ConsumerState<BenchCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  LatLng? _location;
  final _seatCountController = TextEditingController();
  final _materialController = TextEditingController();
  bool _hasBackrest = false;

  @override
  void dispose() {
    _seatCountController.dispose();
    _materialController.dispose();
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

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(benchCreateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bank ekle')),
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
              (_location == null)
                  ? 'Konum seçilmedi'
                  : 'Konum: ${_location!.latitude} , ${_location!.longitude}',
            ),

            TextFormField(
              controller: _seatCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Koltuk Sayısı'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Koltuk sayısı gerekli.';
                }
                if (int.tryParse(value) == null) {
                  return 'Lütfen geçerli bir sayı girin.';
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
