enum PowerSource {
  grid('Şebeke', 'GRID'),
  solar('Güneş Paneli', 'SOLAR');

  final String displayName;
  final String apiValue;

  const PowerSource(this.displayName, this.apiValue);

  static PowerSource fromApiValue(String value) {
    return PowerSource.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
