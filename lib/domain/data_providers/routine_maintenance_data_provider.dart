import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:hive/hive.dart';

class RoutineMaintenanceDataProvider {
  Future<Box<RoutineMaintenance>> _openBox(String vehicleId) async {
    return await BoxManager.instance.openBox(
      name: 'routine_maintenance_box_$vehicleId',
      typeId: 8,
      adapter: RoutineMaintenanceAdapter(),
    );
  }

  Future<void> putRoutineMaintenanceToHive(
      RoutineMaintenance routineMaintenance, String vehicleId) async {
    final box = await _openBox(vehicleId);
    await box.put(routineMaintenance.objectId, routineMaintenance);
    await BoxManager.instance.closeBox(box);
  }

  Future<List<RoutineMaintenance>> getRoutineMaintenancesListFromHive(
      String vehicleId) async {
    final box = await _openBox(vehicleId);
    final list = box.values.toList();
    await BoxManager.instance.closeBox(box);
    return list;
  }

  Future<RoutineMaintenance?> getRoutineMaintenanceFromHive(
      String routineMaintenanceId, String vehicleId) async {
    final box = await _openBox(vehicleId);
    final routineMaintenance = box.get(routineMaintenanceId);
    await BoxManager.instance.closeBox(box);
    return routineMaintenance;
  }

  Future<void> deleteAllRoutineMaintenancesFromHive(String vehicleId) async {
    final box = await _openBox(vehicleId);
    await box.clear();
    await BoxManager.instance.closeBox(box);
  }
}
