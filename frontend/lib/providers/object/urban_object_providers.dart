import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/dio_provider.dart';
import 'package:frontend/services/urban_object_service.dart';
import 'package:frontend/models/entity/urban_object_summary.dart';
import 'package:frontend/models/filter/object_filter.dart';

final urbanObjectServiceProvider = Provider<UrbanObjectService>((ref) {
  return UrbanObjectService(dio: ref.watch(dioProvider));
});

final objectFilterProvider = StateProvider<ObjectFilter>((ref) => const ObjectFilter());

final urbanObjectListProvider = FutureProvider<List<UrbanObjectSummary>>((ref) async {
  final filter = ref.watch(objectFilterProvider);
  final service = ref.watch(urbanObjectServiceProvider);
  return service.getAllUrbanObjects(filter);
});

final urbanObjectDetailProvider = FutureProvider.family<dynamic, int>((
  ref,
  id,
) async {
  final service = ref.watch(urbanObjectServiceProvider);
  return service.getUrbanObjectById(id);
});
