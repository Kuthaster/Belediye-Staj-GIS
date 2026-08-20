enum ObjectType {
  trashBin('Çöp Kutusu', 'TRASH_BIN'),
  bench('Bank', 'BENCH'),
  tree('Ağaç', 'TREE'),
  lightingPole('Aydınlatma Direği', 'LIGHTING_POLE'),
  playgroundEquipment('Oyun Alanı Ekipmanı', 'PLAYGROUND_EQUIPMENT');

  final String displayName;
  final String apiValue;

  const ObjectType(this.displayName, this.apiValue);

  static ObjectType fromApiValue(String value) {
    return ObjectType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
