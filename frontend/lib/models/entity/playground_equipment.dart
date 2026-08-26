import 'package:frontend/models/enum/age_group.dart';
import 'package:frontend/models/enum/equipment_type.dart';
import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';

class PlaygroundEquipment {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final EquipmentType equipmentType;
  final AgeGroup? ageGroup;
  final DateTime? safetyCertificationDate;

  PlaygroundEquipment({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.equipmentType,
    this.ageGroup,
    this.safetyCertificationDate,
  });

  factory PlaygroundEquipment.fromJson(Map<String, dynamic> json) {
    return PlaygroundEquipment(
      id: json['id'],
      type: ObjectType.fromApiValue(json['type']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: ObjectStatus.fromApiValue(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      equipmentType: EquipmentType.fromApiValue(json['equipmentType']),
      ageGroup: AgeGroup.fromApiValue(json['ageGroup']),
      safetyCertificationDate: DateTime.parse(json['safetyCertificationDate']),
    );
  }

  PlaygroundEquipment copyWith({
    EquipmentType? equipmentType,
    AgeGroup? ageGroup,
    DateTime? safetyCertificationDate,
  }) {
    return PlaygroundEquipment(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      equipmentType: equipmentType ?? this.equipmentType,
      ageGroup: ageGroup ?? this.ageGroup,
      safetyCertificationDate:
          safetyCertificationDate ?? this.safetyCertificationDate,
    );
  }
}
