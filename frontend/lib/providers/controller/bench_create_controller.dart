import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/providers/urban_object_providers.dart';

class BenchCreateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {} // no initial state needed

  Future<void> submit(BenchCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      await service.createBench(dto);
    });
  }
}

final benchCreateControllerProvider =
    AsyncNotifierProvider<BenchCreateController, void>(
      BenchCreateController.new,
    );
