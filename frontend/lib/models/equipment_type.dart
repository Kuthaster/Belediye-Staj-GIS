enum EquipmentType {
  swing('Salıncak', 'SWING'),
  slide('Kaydırak', 'SLIDE'),
  teeterTotter('Tahtarevalli', 'TEETER_TOTTER'),
  spinner(
    'Dönen Oyun Elemanı',
    'SPINNER',
  ), //TODO ŞUNUN DOĞRU ADINI BUL ÇOK GENEL BİR TABİR İSİM BULAMIYORUM
  climber('Tırmanma Elemanı', 'CLIMBER');

  final String displayName;
  final String apiValue;

  const EquipmentType(this.displayName, this.apiValue);

  static EquipmentType fromApiValue(String value) {
    return EquipmentType.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
