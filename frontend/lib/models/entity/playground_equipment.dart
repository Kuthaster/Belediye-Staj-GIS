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
      createdAt: DateTime.parse(json['createdAt'] + 'Z'),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] + 'Z')
          : null,
      equipmentType: EquipmentType.fromApiValue(json['equipmentType']),
      ageGroup: json['ageGroup'] != null
          ? AgeGroup.fromApiValue(json['ageGroup'])
          : null,
      safetyCertificationDate: json['safetyCertificationDate'] != null
          ? DateTime.parse(json['safetyCertificationDate'])
          : null,
    );
  }

  PlaygroundEquipment copyWith({
    ObjectStatus? status,
    EquipmentType? equipmentType,
    AgeGroup? ageGroup,
    DateTime? safetyCertificationDate,
  }) {
    return PlaygroundEquipment(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      equipmentType: equipmentType ?? this.equipmentType,
      ageGroup: ageGroup ?? this.ageGroup,
      safetyCertificationDate:
          safetyCertificationDate ?? this.safetyCertificationDate,
    );
  }
}
