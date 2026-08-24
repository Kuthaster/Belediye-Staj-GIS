import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/lighting_pole_create.dart';
import 'package:frontend/providers/urban_object_providers.dart';

class LightingPoleCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(LightingPoleCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      await service.createLightingPole(dto);
    });
  }
}

final lightingPoleCreateControllerProvider =
    AsyncNotifierProvider<LightingPoleCreateController, void>(
      LightingPoleCreateController.new,
    );
