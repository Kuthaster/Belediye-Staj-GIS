import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/tree_create.dart';
import 'package:frontend/models/entity/tree.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';

class TreeCreateController extends AsyncNotifier<Tree?> {
  @override
  Future<Tree?> build() async => null;

  Future<void> submit(TreeCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      return await service.createTree(dto);
    });
  }
}

final treeCreateControllerProvider =
    AsyncNotifierProvider<TreeCreateController, Tree?>(
      TreeCreateController.new,
    );
