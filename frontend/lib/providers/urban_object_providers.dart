import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/urban_object_service.dart';
import 'package:frontend/models/urban_object_summary.dart';

final urbanObjectServiceProvider = Provider<UrbanObjectService>((ref) {
  return UrbanObjectService();
});

final urbanObjectListProvider = FutureProvider<List<UrbanObjectSummary>>((
  ref,
) async {
  final service = ref.watch(urbanObjectServiceProvider);
  return service.getAllUrbanObjects();
});

final urbanObjectDetailProvider = FutureProvider.family<dynamic, int>((
  ref,
  id,
) async {
  final service = ref.watch(urbanObjectServiceProvider);
  return service.getUrbanObjectById(id);
});
