import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/models/entity/bench.dart';
import 'package:frontend/providers/object/urban_object_providers.dart';

class BenchCreateController extends AsyncNotifier<Bench?> {
  @override
  Future<Bench?> build() async => null; // no initial state needed

  Future<void> submit(BenchCreate dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(urbanObjectServiceProvider);
      return await service.createBench(dto);
    });
  }
}

final benchCreateControllerProvider =
    AsyncNotifierProvider<BenchCreateController, Bench?>(
      BenchCreateController.new,
    );
