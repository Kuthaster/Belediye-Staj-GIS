import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/providers/urban_object_providers.dart';

class TrashBinCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(TrashBinCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      await service.createTrashBin(dto);
    });
  }
}

final trashBinCreateControllerProvider =
    AsyncNotifierProvider<TrashBinCreateController, void>(
      TrashBinCreateController.new,
    );
