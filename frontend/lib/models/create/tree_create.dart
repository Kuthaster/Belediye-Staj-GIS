class TreeCreate {
  final double latitude;
  final double longitude;
  final String? species;
  final double? trunkDiameterCm;
  final DateTime? plantingDate;
  final double? heightM;
  final String? healtStatus;

  TreeCreate({
    required this.latitude,
    required this.longitude,
    this.species,
    this.trunkDiameterCm,
    this.plantingDate,
    this.heightM,
    this.healtStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'species': species,
      'trunkDiameterCm': trunkDiameterCm,
      'plantingDate': plantingDate != null
          ? '${plantingDate!.year.toString().padLeft(4, '0')}-${plantingDate!.month.toString().padLeft(2, '0')}-${plantingDate!.day.toString().padLeft(2, '0')}'
          : null,
      'heightM': heightM,
      'healtStatus': healtStatus,
    };
  }
}
