enum AgeGroup {
  preschool(
    'Okul Öncesi',
    'PRESCHOOL',
  ), //0-7 TODO BU RAKAMLARI GARANTİLEYEN BİR ŞEY BUL
  elementary('İlköğretim Çağı', 'ELEMENTARY'), //7- 14
  allAges('Her Yaş', 'ALL_AGES');

  final String displayName;
  final String apiValue;

  const AgeGroup(this.displayName, this.apiValue);

  static AgeGroup fromApiValue(String value) {
    return AgeGroup.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
