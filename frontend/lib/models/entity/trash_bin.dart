import 'package:frontend/models/enum/bin_type.dart';
import 'package:frontend/models/enum/object_status.dart';
import 'package:frontend/models/enum/object_type.dart';

class TrashBin {
  final int id;
  final ObjectType type;
  final double latitude;
  final double longitude;
  final ObjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? volumeLiters;
  final BinType binType;
  final String? material;
  final int? collectionFrequencyDays;

  TrashBin({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.volumeLiters,
    required this.binType,
    this.material,
    this.collectionFrequencyDays,
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
      volumeLiters: json['volumeLiters'],
      binType: BinType.fromApiValue(json['binType']),
      material: json['material'],
      collectionFrequencyDays: json['collectionFrequencyDays'],
    );
  }

  TrashBin copyWith({
    double? volumeLiters,
    BinType? binType,
    String? material,
    int? collectionFrequencyDays,
  }) {
    return TrashBin(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      volumeLiters: volumeLiters ?? this.volumeLiters,
      binType: binType ?? this.binType,
      material: material ?? this.material,
      collectionFrequencyDays:
          collectionFrequencyDays ?? this.collectionFrequencyDays,
    );
  }
}
