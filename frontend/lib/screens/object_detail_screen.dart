import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/models/entity/bench.dart';
import 'package:frontend/models/entity/tree.dart';
import 'package:frontend/models/entity/trash_bin.dart';
import 'package:frontend/models/entity/lighting_pole.dart';
import 'package:frontend/models/entity/playground_equipment.dart';

class ObjectDetailScreen extends ConsumerWidget {
  final int id;

  const ObjectDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(urbanObjectDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Cisim detayları')),
      body: detailAsync.when(
        data: (obj) => _buildDetail(obj),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Yüklenemedi: $err')),
      ),
    );
  }

  Widget _buildDetail(dynamic obj) {
    if (obj is Bench) {
      return _detailList({
        'Koltuk Sayısı': obj.seatCount.toString(),
        'Materyal': obj.material ?? '-',
        'Sırtlığı Var': obj.hasBackrest.toString(),
      });
    }
    if (obj is Tree) {
      return _detailList({
        'Tür': obj.species ?? '-',
        'Dikilme Tarihi': obj.plantingDate?.toString() ?? '-',
        'Gövde Çapı (cm)': obj.trunkDiameterCm?.toString() ?? '-',
        'Yükseklik (m)': obj.heightM?.toString() ?? '-',
      });
    }
    if (obj is TrashBin) {
      return _detailList({
        'Hacim (L)': obj.volumeLiters?.toString() ?? '-',
        'Teneke Türü': obj.binType.displayName,
        'Materyal': obj.material ?? '-',
        'Toplama Sıklığı (Gün)': obj.collectionFrequencyDays?.toString() ?? '-',
      });
    }
    if (obj is LightingPole) {
      return _detailList({
        'Voltaj': obj.wattage?.toString() ?? '-',
        'Yükseklik (m)': obj.heightM?.toString() ?? '-',
        'Aydınlatma Tipi': obj.lightType.displayName,
        'Güç Kaynağı': obj.powerSource.displayName,
      });
    }
    if (obj is PlaygroundEquipment) {
      return _detailList({
        'Ekipman Türü': obj.equipmentType.displayName,
        'Yaş Aralığı': obj.ageGroup?.displayName ?? '-',
      });
    }
    return const Center(child: Text('Bilinmeyen Cisim Türü'));
  }

  Widget _detailList(Map<String, String> fields) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: fields.entries
          .map((e) => ListTile(title: Text(e.key), subtitle: Text(e.value)))
          .toList(),
    );
  }
}
