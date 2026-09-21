// ignore_for_file: constant_identifier_names

enum Role {
  admin('Admin', 'ADMIN'),
  viewer('Görüntüleyici', 'VIEWER'),
  fieldWorker('Saha Görevlisi', 'FIELD_WORKER'),
  fieldSupervisor('Saha Sorumlusu', 'FIELD_SUPERVISOR');

  final String displayName;
  final String apiValue;

  const Role(this.displayName, this.apiValue);

  static Role fromApiValue(String value) {
    return Role.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => throw ArgumentError('Bilinmeyen Cisim Türü: $value'),
    );
  }

  bool get canDelete => this == Role.admin || this == Role.fieldSupervisor;
  bool get canChangeStatus =>
      this == Role.admin || this == Role.fieldSupervisor;
  bool get isAdmin => this == Role.admin;
  bool get canEditPhoto => this == Role.admin || this == Role.fieldWorker;
}
