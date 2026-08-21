import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';

class Bench {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int seatCount;
  final String? material;
  final bool hasBackrest;

  Bench({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.seatCount,
    this.material,
    required this.hasBackrest,
  });

  factory Bench.fromJson(Map<String, dynamic> json) {
    return Bench(
      id: json['id'],
      type: ObjectType.fromApiValue(json['type']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: ObjectStatus.fromApiValue(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      seatCount: json['seatCount'],
      material: json['material'],
      hasBackrest: json['hasBackrest'],
    );
  }
}
