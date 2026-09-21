import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/models/entity/trash_bin.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';

class TrashBinCreateController extends AsyncNotifier<TrashBin?> {
  @override
  Future<TrashBin?> build() async => null;

  Future<void> submit(TrashBinCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      return await service.createTrashBin(dto);
    });
  }
}

final trashBinCreateControllerProvider =
    AsyncNotifierProvider<TrashBinCreateController, TrashBin?>(
      TrashBinCreateController.new,
    );
