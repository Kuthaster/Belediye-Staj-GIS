import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';

class UrbanObjectSummary {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UrbanObjectSummary({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory UrbanObjectSummary.fromJson(Map<String, dynamic> json) {
    return UrbanObjectSummary(
      id: json['id'],
      type: ObjectType.fromApiValue(json['type']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: ObjectStatus.fromApiValue(json['status']),
      createdAt: DateTime.parse(json['createdAt'] + 'Z'),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] + 'Z')
          : null,
    );
  }
}
