import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';

class Tree {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? species;
  final DateTime? plantingDate;
  final double? trunkDiameterCm;
  final double? heightM;
  final String? healthStatus;

  Tree({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.species,
    this.plantingDate,
    this.trunkDiameterCm,
    this.heightM,
    this.healthStatus,
  });

  factory Tree.fromJson(Map<String, dynamic> json) {
    return Tree(
      id: json['id'],
      type: ObjectType.fromApiValue(json['type']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: ObjectStatus.fromApiValue(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      species: json['species'],
      plantingDate: DateTime.parse(json['plantingDate']),
      trunkDiameterCm: json['trunkDiameterCm'],
      heightM: json['heightM'],
      healthStatus: json['healthStatus'],
    );
  }
}
