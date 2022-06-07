import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'routine_maintenance.g.dart';

@HiveType(typeId: 8)
class RoutineMaintenance extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String title;
  @HiveField(2)
  int periodicity;
  @HiveField(3)
  int engineHoursValue;
  @HiveField(4)
  String vehicleNode;
  RoutineMaintenance({
    required this.objectId,
    required this.title,
    required this.periodicity,
    required this.engineHoursValue,
    required this.vehicleNode,
  });

  void updateRoutineMaintenance(
    String? title,
    String? vehicleNode,
    int? periodicity,
    int? engineHoursValue,
  ) {
    if (title != null) {
      this.title = title;
    }
    if (vehicleNode != null) {
      this.vehicleNode = vehicleNode;
    }
    if (periodicity != null) {
      this.periodicity = periodicity;
    }
    if (engineHoursValue != null) {
      this.engineHoursValue = engineHoursValue;
    }
  }

  int get remainEngineHours => periodicity - engineHoursValue;

  static RoutineMaintenance getRoutineMaintenance({
    required ParseObject routineMaintenanceObject,
  }) {
    final objectId = routineMaintenanceObject.objectId ?? 'Нет objectId';
    final title =
        routineMaintenanceObject.get<String>('title') ?? 'Название не указано';
    final vehicleNode = routineMaintenanceObject.get<String>('vehicleNode') ??
        'Узел автомобиля не указан';
    final periodicity = routineMaintenanceObject.get<int>('periodicity') ?? 0;
    final engineHoursValue =
        routineMaintenanceObject.get<int>('engineHoursValue') ?? 0;

    return RoutineMaintenance(
      objectId: objectId,
      title: title,
      periodicity: periodicity,
      engineHoursValue: engineHoursValue,
      vehicleNode: vehicleNode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoutineMaintenance &&
        other.objectId == objectId &&
        other.title == title &&
        other.periodicity == periodicity &&
        other.engineHoursValue == engineHoursValue &&
        other.vehicleNode == vehicleNode;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        title.hashCode ^
        periodicity.hashCode ^
        engineHoursValue.hashCode ^
        vehicleNode.hashCode;
  }
}
