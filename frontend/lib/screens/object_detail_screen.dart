import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/models/create/lighting_pole_create.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/models/create/tree_create.dart';
import 'package:frontend/models/entity/bench.dart';
import 'package:frontend/models/entity/lighting_pole.dart';
import 'package:frontend/models/entity/playground_equipment.dart';
import 'package:frontend/models/entity/trash_bin.dart';
import 'package:frontend/models/entity/tree.dart';
import 'package:frontend/models/enum/age_group.dart';
import 'package:frontend/models/enum/bin_type.dart';
import 'package:frontend/models/enum/equipment_type.dart';
import 'package:frontend/models/enum/light_type.dart';
import 'package:frontend/models/enum/power_source.dart';
import 'package:frontend/providers/urban_object_providers.dart';
import 'package:frontend/widgets/editable_date_field.dart';
import 'package:frontend/widgets/editable_enum_field.dart';
import 'package:frontend/widgets/editable_text_field.dart';
import 'package:frontend/widgets/editable_number_field.dart';
import 'package:frontend/widgets/editable_bool_field.dart';
import 'package:frontend/services/error_interceptor.dart';

class ObjectDetailScreen extends ConsumerStatefulWidget {
  final int id;

  const ObjectDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ObjectDetailScreen> createState() => _ObjectDetailScreenState();
}

class _ObjectDetailScreenState extends ConsumerState<ObjectDetailScreen> {
  dynamic _draft;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(urbanObjectDetailProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cisim Detayları'),
        actions: [
          if (_isDirty)
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveChanges,
            ),
        ],
      ),
      body: detailAsync.when(
        data: (obj) {
          _draft ??= obj;
          return _buildFields();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Yüklenemedi: $err')),
      ),
    );
  }

  Widget _buildFields() {
    if (_draft is Bench) {
      final b = _draft as Bench;
      return ListView(
        children: [
          EditableNumberField(
            label: 'Koltuk Sayısı',
            value: b.seatCount,
            isInt: true,
            onChanged: (newSeatCount) =>
                _updateDraft(b.copyWith(seatCount: newSeatCount as int?)),
          ),
          EditableTextField(
            label: 'Materyal',
            value: b.material,
            onChanged: (newMaterial) =>
                _updateDraft(b.copyWith(material: newMaterial)),
          ),
          EditableBoolField(
            label: 'Sırtlığı Var',
            value: b.hasBackrest,
            onChanged: (br) => _updateDraft(b.copyWith(hasBackrest: br)),
          ),
        ],
      );
    }

    if (_draft is LightingPole) {
      final lp = _draft as LightingPole;
      return ListView(
        children: [
          EditableNumberField(
            label: 'Voltaj',
            value: lp.wattage,
            isInt: true,
            onChanged: (w) => _updateDraft(lp.copyWith(wattage: w as int?)),
          ),
          EditableNumberField(
            label: 'Yükseklik (m)',
            value: lp.heightM,
            isInt: false,
            onChanged: (newHeightM) =>
                _updateDraft(lp.copyWith(heightM: newHeightM as double?)),
          ),
          EditableEnumField<LightType>(
            label: 'Işık Tipi',
            value: lp.lightType,
            options: LightType.values,
            displayName: (t) => t.displayName,
            onChanged: (newlightType) =>
                _updateDraft(lp.copyWith(lightType: newlightType)),
          ),
          EditableEnumField<PowerSource>(
            label: 'Güç Kaynağı',
            value: lp.powerSource,
            options: PowerSource.values,
            displayName: (t) => t.displayName,
            onChanged: (newPowerSource) =>
                _updateDraft(lp.copyWith(powerSource: newPowerSource)),
          ),
        ],
      );
    }

    if (_draft is Tree) {
      final t = _draft as Tree;
      return ListView(
        children: [
          EditableTextField(
            label: 'Tür',
            value: t.species,
            onChanged: (s) => _updateDraft(t.copyWith(species: s)),
          ),
          EditableDateField(
            label: 'Dikim Tarihi',
            value: t.plantingDate,
            onChanged: (newPlantingDate) =>
                _updateDraft(t.copyWith(plantingDate: newPlantingDate)),
          ),
          EditableNumberField(
            label: 'Gövde Çapı (cm)',
            value: t.trunkDiameterCm,
            isInt: false,
            onChanged: (newTrunkDiameterCm) => _updateDraft(
              t.copyWith(trunkDiameterCm: newTrunkDiameterCm as double?),
            ),
          ),

          EditableNumberField(
            label: 'Yükseklik (m)',
            value: t.heightM,
            isInt: false,
            onChanged: (newHeightM) =>
                _updateDraft(t.copyWith(heightM: newHeightM as double?)),
          ),
          EditableTextField(
            label: 'Sağlık Durumu',
            value: t.healthStatus,
            onChanged: (newHealthStatus) =>
                _updateDraft(t.copyWith(healthStatus: newHealthStatus)),
          ),
        ],
      );
    }

    if (_draft is TrashBin) {
      final tb = _draft as TrashBin;
      return ListView(
        children: [
          EditableEnumField(
            label: 'Çöp kutusu tipi',
            value: tb.binType,
            options: BinType.values,
            displayName: (t) => t.displayName,
            onChanged: (newBinType) =>
                _updateDraft(tb.copyWith(binType: newBinType)),
          ),

          EditableNumberField(
            label: 'Hacim (L)',
            value: tb.volumeLiters,
            isInt: false,
            onChanged: (newVolumeLiters) => _updateDraft(
              tb.copyWith(volumeLiters: newVolumeLiters as double?),
            ),
          ),

          EditableNumberField(
            label: 'Toplama Sıklığı (gün)',
            value: tb.collectionFrequencyDays,
            isInt: true,
            onChanged: (newCollectionFrequencyDays) => _updateDraft(
              tb.copyWith(
                collectionFrequencyDays: newCollectionFrequencyDays as int?,
              ),
            ),
          ),

          EditableTextField(
            label: 'Materyal',
            value: tb.material,
            onChanged: (newMaterial) =>
                _updateDraft(tb.copyWith(material: newMaterial)),
          ),
        ],
      );
    }

    if (_draft is PlaygroundEquipment) {
      final pe = _draft as PlaygroundEquipment;
      return ListView(
        children: [
          EditableEnumField(
            label: 'Ekipman Tipi',
            value: pe.equipmentType,
            options: EquipmentType.values,
            displayName: (t) => t.displayName,
            onChanged: (newEquipmenttype) =>
                _updateDraft(pe.copyWith(equipmentType: newEquipmenttype)),
          ),

          EditableEnumField(
            label: 'Yaş Aralığı',
            value: pe.ageGroup,
            options: AgeGroup.values,
            displayName: (t) => t.displayName,
            onChanged: (newAgeGroup) =>
                _updateDraft(pe.copyWith(ageGroup: newAgeGroup)),
          ),

          EditableDateField(
            label: 'Güvenlik Sertifikası Verilme Tarihi',
            value: pe.safetyCertificationDate,
            onChanged: (newCertDate) =>
                _updateDraft(pe.copyWith(safetyCertificationDate: newCertDate)),
          ),
        ],
      );
    }

    return const Center(child: Text('Unsupported object type'));
  }

  void _updateDraft(dynamic newDraft) {
    setState(() {
      _draft = newDraft;
      _isDirty = true;
    });
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      final service = ref.read(urbanObjectServiceProvider);

      if (_draft is Bench) {
        final b = _draft as Bench;
        final dto = BenchCreate(
          latitude: b.latitude,
          longitude: b.longitude,
          seatCount: b.seatCount,
          material: b.material,
          hasBackrest: b.hasBackrest,
        );
        await service.updateBench(widget.id, dto);
      }

      if (_draft is Tree) {
        final t = _draft as Tree;
        final dto = TreeCreate(
          latitude: t.latitude,
          longitude: t.longitude,
          species: t.species,
          trunkDiameterCm: t.trunkDiameterCm,
          plantingDate: t.plantingDate,
          heightM: t.heightM,
          healthStatus: t.healthStatus,
        );
        await service.updateTree(widget.id, dto);
      }

      if (_draft is TrashBin) {
        final tb = _draft as TrashBin;
        final dto = TrashBinCreate(
          latitude: tb.latitude,
          longitude: tb.longitude,
          volumeLiters: tb.volumeLiters,
          binType: tb.binType,
          material: tb.material,
          collectionFrequencyDays: tb.collectionFrequencyDays,
        );
        await service.updateTrashBin(widget.id, dto);
      }
      if (_draft is PlaygroundEquipment) {
        final pe = _draft as PlaygroundEquipment;
        final dto = PlaygroundEquipmentCreate(
          latitude: pe.latitude,
          longitude: pe.longitude,
          equipmentType: pe.equipmentType,
          ageGroup: pe.ageGroup,
          safetyCertificationDate: pe.safetyCertificationDate,
        );
        await service.updatePlaygroundEquipment(widget.id, dto);
      }

      if (_draft is LightingPole) {
        final lp = _draft as LightingPole;
        final dto = LightingPoleCreate(
          latitude: lp.latitude,
          longitude: lp.longitude,
          wattage: lp.wattage,
          heightM: lp.heightM,
          lightType: lp.lightType,
          powerSource: lp.powerSource,
        );
        await service.updateLightingPole(widget.id, dto);
      }

      ref.invalidate(urbanObjectDetailProvider(widget.id));
      ref.invalidate(urbanObjectListProvider);

      setState(() => _isDirty = false);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved.')));
      }
    } catch (e) {
      final message = e is AppException ? e.message : 'Failed to save changes.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
