import '../enum/light_type.dart';
import '../enum/power_source.dart';

class LightingPoleCreate {
  final double? latitude;
  final double? longitude;
  final int? wattage;
  final double? heightM;
  final LightType lightType;
  final PowerSource powerSource;

  LightingPoleCreate({
    this.latitude,
    this.longitude,
    this.wattage,
    this.heightM,
    required this.lightType,
    required this.powerSource,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'wattage': wattage,
      'heightM': heightM,
      'lightType': lightType.apiValue,
      'powerSource': powerSource.apiValue,
    };
  }
}
