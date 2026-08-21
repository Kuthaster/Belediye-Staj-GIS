class BenchCreate {
  final double latitude;
  final double longitude;
  final int seatCount;
  final String? material;
  final bool hasBackrest;

  BenchCreate({
    required this.latitude,
    required this.longitude,
    required this.seatCount,
    this.material,
    required this.hasBackrest,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'seatCount': seatCount,
      'material': material,
      'hasBackrest': hasBackrest,
    };
  }
}
