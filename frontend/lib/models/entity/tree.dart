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
      createdAt: DateTime.parse(json['createdAt'] + 'Z'),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] + 'Z')
          : null,
      species: json['species'],
      plantingDate: json['plantingDate'] != null
          ? DateTime.parse(json['plantingDate'])
          : null,
      trunkDiameterCm: json['trunkDiameterCm'],
      heightM: json['heightM'],
      healthStatus: json['healthStatus'],
    );
  }

  Tree copyWith({
    ObjectStatus? status,
    String? species,
    DateTime? plantingDate,
    double? trunkDiameterCm,
    double? heightM,
    String? healthStatus,
  }) {
    return Tree(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      species: species ?? this.species,
      plantingDate: plantingDate ?? this.plantingDate,
      trunkDiameterCm: trunkDiameterCm ?? this.trunkDiameterCm,
      heightM: heightM ?? this.heightM,
      healthStatus: healthStatus ?? this.healthStatus,
    );
  }
}
