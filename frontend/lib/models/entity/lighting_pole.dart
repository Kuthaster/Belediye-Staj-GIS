import 'package:frontend/models/enum/light_type.dart';
import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/models/enum/power_source.dart';

class LightingPole {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? wattage;
  final double? heightM;
  final LightType lightType;
  final PowerSource powerSource;

  LightingPole({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.wattage,
    this.heightM,
    required this.lightType,
    required this.powerSource,
  });

  factory LightingPole.fromJson(Map<String, dynamic> json) {
    return LightingPole(
      id: json['id'],
      type: ObjectType.fromApiValue(json['type']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: ObjectStatus.fromApiValue(json['status']),
      createdAt: DateTime.parse(json['createdAt'] + 'Z'),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] + 'Z')
          : null,
      wattage: json['wattage'],
      heightM: json['heightM'],
      lightType: LightType.fromApiValue(json['lightType']),
      powerSource: PowerSource.fromApiValue(json['powerSource']),
    );
  }

  LightingPole copyWith({
    ObjectStatus? status,
    int? wattage,
    double? heightM,
    LightType? lightType,
    PowerSource? powerSource,
  }) {
    return LightingPole(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      wattage: wattage ?? this.wattage,
      heightM: heightM ?? this.heightM,
      lightType: lightType ?? this.lightType,
      powerSource: powerSource ?? this.powerSource,
    );
  }
}
