enum AgeGroup {
  preschool(
    'Okul Öncesi',
    'PRESCHOOL',
  ),
  elementary('İlköğretim Çağı', 'ELEMENTARY'), //7- 14
  allAges('Her Yaş', 'ALL_AGES');

  final String displayName;
  final String apiValue;

  const AgeGroup(this.displayName, this.apiValue);

  static AgeGroup? fromApiValue(String? value) {
    if (value == null) return null;
    return AgeGroup.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen yaş aralığı: $value'),
    );
  }
}
