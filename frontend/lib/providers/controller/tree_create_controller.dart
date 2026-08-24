import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/tree_create.dart';
import 'package:frontend/providers/urban_object_providers.dart';

class TreeCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(TreeCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      await service.createTree(dto);
    });
  }
}

final treeCreateControllerProvider =
    AsyncNotifierProvider<TreeCreateController, void>(TreeCreateController.new);
