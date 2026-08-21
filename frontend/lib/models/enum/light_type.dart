enum LightType {
  led('Led', 'LED'),
  sodium('Sodyum', 'SODIUM');

  final String displayName;
  final String apiValue;

  const LightType(this.displayName, this.apiValue);

  static LightType fromApiValue(String value) {
    return LightType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
