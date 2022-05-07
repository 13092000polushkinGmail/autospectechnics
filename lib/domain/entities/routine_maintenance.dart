import 'package:parse_server_sdk/parse_server_sdk.dart';

class RoutineMaintenance {
  final String objectId;
  final String title;
  final int periodicity;
  int engineHoursValue;
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
