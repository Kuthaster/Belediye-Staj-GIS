import 'package:frontend/models/enum/object_type.dart';
import 'package:frontend/models/enum/object_status.dart';

class ObjectFilter {
  final ObjectType? type;
  final ObjectStatus? status;
  final DateTime? createdFrom;
  final DateTime? createdTo;

  const ObjectFilter({
    this.type,
    this.status,
    this.createdFrom,
    this.createdTo,
  });

  bool get isEmpty =>
      type == null &&
      status == null &&
      createdFrom == null &&
      createdTo == null;

  ObjectFilter copyWith({
    ObjectType? type,
    ObjectStatus? status,
    DateTime? createdFrom,
    DateTime? createdTo,
    bool clearType = false,
    bool clearStatus = false,
    bool clearCreatedFrom = false,
    bool clearCreatedTo = false,
  }) {
    return ObjectFilter(
      type: clearType ? null : (type ?? this.type),
      status: clearStatus ? null : (status ?? this.status),
      createdFrom: clearCreatedFrom ? null : (createdFrom ?? this.createdFrom),
      createdTo: clearCreatedTo ? null : (createdTo ?? this.createdTo),
    );
  }

  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};
    if (type != null) map['type'] = type!.apiValue;
    if (status != null) map['status'] = status!.apiValue;
    if (createdFrom != null) {
      map['createdFrom'] = createdFrom!.toIso8601String().split('T').first;
    }
    if (createdTo != null) {
      map['createdTo'] = createdTo!.toIso8601String().split('T').first;
    }
    return map;
  }
}
