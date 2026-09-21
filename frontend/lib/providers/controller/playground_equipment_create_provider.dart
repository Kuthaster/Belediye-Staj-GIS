import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/models/entity/playground_equipment.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';

class PlaygroundEquipmentCreateProvider
    extends AsyncNotifier<PlaygroundEquipment?> {
  @override
  Future<PlaygroundEquipment?> build() async => null;

  Future<void> submit(PlaygroundEquipmentCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      return await service.createPlaygroundEquipment(dto);
    });
  }
}

final playgroundEquipmentControllerProvider =
    AsyncNotifierProvider<
      PlaygroundEquipmentCreateProvider,
      PlaygroundEquipment?
    >(PlaygroundEquipmentCreateProvider.new);
