import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/providers/urban_object_providers.dart';

class PlaygroundEquipmentCreateProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(PlaygroundEquipmentCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      await service.createPlaygroundEquipment(dto);
    });
  }
}

final playGroundEquipmentControllerProvider =
    AsyncNotifierProvider<PlaygroundEquipmentCreateProvider, void>(
      PlaygroundEquipmentCreateProvider.new,
    );
