import 'package:frontend/models/enum/age_group.dart';
import 'package:frontend/models/enum/equipment_type.dart';

class PlaygroundEquipmentCreate {
  final double latitude;
  final double longitude;
  final EquipmentType eqiupmentType;
  final AgeGroup? ageGroup;
  final DateTime? safetyCertificationDate;

  PlaygroundEquipmentCreate({
    required this.latitude,
    required this.longitude,
    required this.eqiupmentType,
    this.ageGroup,
    this.safetyCertificationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'eqiupmentType': eqiupmentType.apiValue,
      'ageGroup': ageGroup?.apiValue,
      'safetyCertificationDate': safetyCertificationDate != null
          ? '${safetyCertificationDate!.year.toString().padLeft(4, '0')}-${safetyCertificationDate!.month.toString().padLeft(2, '0')}-${safetyCertificationDate!.day.toString().padLeft(2, '0')}'
          : null,
    };
  }
}
