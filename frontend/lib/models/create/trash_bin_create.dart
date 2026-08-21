import '../enum/bin_type.dart';

class TrashBinCreate {
  final double latitude;
  final double longitude;
  final double? volumeLiters;
  final BinType binType;
  final String? material;
  final int? collectionFrequencyDays;

  TrashBinCreate({
    required this.latitude,
    required this.longitude,
    this.volumeLiters,
    required this.binType,
    this.material,
    this.collectionFrequencyDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'volumeLiters': volumeLiters,
      'binType': binType.apiValue,
      'material': material,
      'collectionFrequencyDays': collectionFrequencyDays,
    };
  }
}
