import 'package:frontend/models/age_group.dart';
import 'package:frontend/models/equipment_type.dart';
import 'package:frontend/models/object_status.dart';
import 'package:frontend/models/object_type.dart';

class TrashBin {
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

  TrashBin({
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

  factory TrashBin.fromJson(Map<String, dynamic> json) {
    return TrashBin(
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
}
