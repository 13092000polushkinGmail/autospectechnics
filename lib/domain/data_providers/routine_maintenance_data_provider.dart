import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:hive/hive.dart';

class RoutineMaintenanceDataProvider {
  late Future<Box<RoutineMaintenance>> _futureBox;
  final String _vehicleId;
  RoutineMaintenanceDataProvider(this._vehicleId) {
    _futureBox = BoxManager.instance.openBox(
      name: 'routine_maintenance_box_$_vehicleId',
      typeId: 8,
      adapter: RoutineMaintenanceAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getRoutineMaintenanceStream() async {
    final box = await _futureBox;
    final routineMaintenanceStream = box.watch();
    return routineMaintenanceStream;
  }

  Future<void> putRoutineMaintenanceToHive(
      RoutineMaintenance routineMaintenance) async {
    final box = await _futureBox;
    final routineMaintenanceFromHive = box.get(routineMaintenance.objectId);
    if (routineMaintenanceFromHive == null ||
        routineMaintenanceFromHive != routineMaintenance) {
      await box.put(routineMaintenance.objectId, routineMaintenance);
    }
  }

  Future<void> updateRoutineMaintenanceInHive({
    required String routineMaintenanceId,
    String? title,
    String? vehicleNode,
    int? periodicity,
    int? engineHoursValue,
  }) async {
    final box = await _futureBox;
    final routineMaintenance = box.get(routineMaintenanceId);
    if (routineMaintenance != null) {
      routineMaintenance.updateRoutineMaintenance(
        title,
        vehicleNode,
        periodicity,
        engineHoursValue,
      );
      await routineMaintenance.save();
    }
  }

  Future<void> deleteRoutineMaintenanceFromHive(
      String routineMaintenanceId) async {
    final box = await _futureBox;
    await box.delete(routineMaintenanceId);
  }

  Future<List<RoutineMaintenance>> getRoutineMaintenancesListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<RoutineMaintenance?> getRoutineMaintenanceFromHive(
      String routineMaintenanceId) async {
    final box = await _futureBox;
    final routineMaintenance = box.get(routineMaintenanceId);
    return routineMaintenance;
  }

  Future<void> deleteUnnecessaryRoutineMaintenancesFromHive(
      List<RoutineMaintenance> vehicleRoutineMaintenancesFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var routineMaintenance in vehicleRoutineMaintenancesFromServer) {
      if (keysToDelete.contains(routineMaintenance.objectId)) {
        keysToDelete.remove(routineMaintenance.objectId);
      }
    }
    box.deleteAll(keysToDelete);
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
