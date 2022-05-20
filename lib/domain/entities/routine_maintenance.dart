import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'routine_maintenance.g.dart';

@HiveType(typeId: 8)
class RoutineMaintenance {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int periodicity;
  @HiveField(3)
  int engineHoursValue;
  @HiveField(4)
  final String vehicleNode;
  RoutineMaintenance({
    required this.objectId,
    required this.title,
    required this.periodicity,
    required this.engineHoursValue,
    required this.vehicleNode,
  });

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
}
