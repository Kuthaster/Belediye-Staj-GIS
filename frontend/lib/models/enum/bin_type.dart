enum BinType {
  general('Genel', 'GENERAL'),
  recycling('Geri Dönüşüm', 'RECYCLING'),
  organic('Organik', 'ORGANIC');

  final String displayName;
  final String apiValue;

  const BinType(this.displayName, this.apiValue);

  static BinType fromApiValue(String value) {
    return BinType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
