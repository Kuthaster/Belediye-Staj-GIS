// ignore_for_file: constant_identifier_names

enum Role {
  admin('Admin', 'ADMIN'),
  viewer('Görüntüleyici', 'VIEWER'),
  fieldWorker('Saha Görevlisi', 'FIELD_WORKER');

  final String displayName;
  final String apiValue;

  const Role(this.displayName, this.apiValue);

  static Role fromApiValue(String value) {
    return Role.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }
}
