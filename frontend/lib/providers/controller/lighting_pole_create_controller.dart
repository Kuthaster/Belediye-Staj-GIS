import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/lighting_pole_create.dart';
import 'package:frontend/models/entity/lighting_pole.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';

class LightingPoleCreateController extends AsyncNotifier<LightingPole?> {
  @override
  Future<LightingPole?> build() async => null;

  Future<void> submit(LightingPoleCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      return await service.createLightingPole(dto);
    });
  }
}

final lightingPoleCreateControllerProvider =
    AsyncNotifierProvider<LightingPoleCreateController, LightingPole?>(
      LightingPoleCreateController.new,
    );
