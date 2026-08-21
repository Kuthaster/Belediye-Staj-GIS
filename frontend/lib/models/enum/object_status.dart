enum ObjectStatus {
  active('Aktif', 'ACTIVE'),
  needsMaintenance('Bakım Gerekli', 'NEEDS_MAINTENANCE'),
  broken('Kırık', 'BROKEN'),
  removed('Kaldırıldı', 'REMOVED');

  final String displayName;
  final String apiValue;

  const ObjectStatus(this.displayName, this.apiValue);

  static ObjectStatus fromApiValue(String value) {
    return ObjectStatus.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
