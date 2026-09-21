import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/screens/location_picker_screen.dart';

class LocationPickerButton extends StatelessWidget {
  final LatLng? value;
  final ValueChanged<LatLng> onChanged;

  const LocationPickerButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(initialLocation: value),
      ),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        value == null
            ? 'Konum seçilmedi'
            : 'Konum: ${value!.latitude.toStringAsFixed(5)}, ${value!.longitude.toStringAsFixed(5)}',
      ),
      trailing: const Icon(Icons.map),
      onTap: () => _openPicker(context),
    );
  }
}
