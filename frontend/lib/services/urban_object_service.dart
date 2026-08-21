import 'package:dio/dio.dart';
import 'package:frontend/models/entity/bench.dart';
import 'package:frontend/models/create/bench_create.dart';
import 'package:frontend/models/entity/lighting_pole.dart';
import 'package:frontend/models/create/lighting_pole_create.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/models/entity/playground_equipment.dart';
import 'package:frontend/models/create/playground_equipment_create.dart';
import 'package:frontend/models/entity/trash_bin.dart';
import 'package:frontend/models/create/trash_bin_create.dart';
import 'package:frontend/models/entity/tree.dart';
import 'package:frontend/models/create/tree_create.dart';
import 'package:frontend/models/urban_object_summary.dart';
import 'package:frontend/services/api_client.dart';

class UrbanObjectService {
  final Dio _dio;

  UrbanObjectService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<UrbanObjectSummary>> getAllUrbanObjects() async {
    final response = await _dio.get('/objects');
    return (response.data as List)
        .map((item) => UrbanObjectSummary.fromJson(item))
        .toList();
  }

  Future<dynamic> getUrbanObjectById(int id) async {
    final response = await _dio.get('/objects/$id');
    final data = response.data as Map<String, dynamic>;
    final type = ObjectType.fromApiValue(data['type']);

    switch (type) {
      case ObjectType.bench:
        return Bench.fromJson(data);
      case ObjectType.trashBin:
        return TrashBin.fromJson(data);
      case ObjectType.tree:
        return Tree.fromJson(data);
      case ObjectType.lightingPole:
        return LightingPole.fromJson(data);
      case ObjectType.playgroundEquipment:
        return PlaygroundEquipment.fromJson(data);
    }
  }

  Future<Bench> createBench(BenchCreate dto) async {
    final response = await _dio.post('/objects/benches', data: dto.toJson());
    return Bench.fromJson(response.data);
  }

  Future<Tree> createTree(TreeCreate dto) async {
    final response = await _dio.post('/objects/trees', data: dto.toJson());
    return Tree.fromJson(response.data);
  }

  Future<PlaygroundEquipment> createPlaygroundEquipment(
    PlaygroundEquipmentCreate dto,
  ) async {
    final response = await _dio.post(
      '/objects/playground-equipment',
      data: dto.toJson(),
    );
    return PlaygroundEquipment.fromJson(response.data);
  }

  Future<LightingPole> createLightingPole(LightingPoleCreate dto) async {
    final response = await _dio.post(
      '/objects/lighting-poles',
      data: dto.toJson(),
    );
    return LightingPole.fromJson(response.data);
  }

  Future<TrashBin> createTrashBin(TrashBinCreate dto) async {
    final response = await _dio.post('/objects/trash-bins', data: dto.toJson());
    return TrashBin.fromJson(response.data);
  }

  Future<void> deleteUrbanObject(int id) async {
    await _dio.delete('/objects/$id');
  }

  Future<Bench> updateBench(int id, BenchCreate dto) async {
    final response = await _dio.put('/objects/benches/$id', data: dto.toJson());
    return Bench.fromJson(response.data);
  }

  Future<Tree> updateTree(int id, TreeCreate dto) async {
    final response = await _dio.put('/objects/trees/$id', data: dto.toJson());
    return Tree.fromJson(response.data);
  }

  Future<PlaygroundEquipment> updatePlaygroundEquipment(
    int id,
    PlaygroundEquipmentCreate dto,
  ) async {
    final response = await _dio.put(
      '/objects/playground-equipment/$id',
      data: dto.toJson(),
    );
    return PlaygroundEquipment.fromJson(response.data);
  }

  Future<TrashBin> updateTrashBin(int id, TrashBinCreate dto) async {
    final response = await _dio.put(
      '/objects/trash-bins/$id',
      data: dto.toJson(),
    );
    return TrashBin.fromJson(response.data);
  }

  Future<LightingPole> updateLightingPole(
    int id,
    LightingPoleCreate dto,
  ) async {
    final response = await _dio.put(
      '/objects/lighting-poles/$id',
      data: dto.toJson(),
    );
    return LightingPole.fromJson(response.data);
  }
}
