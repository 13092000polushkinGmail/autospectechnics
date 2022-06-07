import 'package:autospectechnics/domain/api_clients/routine_maintenance_api_client.dart';
import 'package:autospectechnics/domain/data_providers/routine_maintenance_data_provider.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:hive/hive.dart';

class RoutineMaintenanceService {
  final _routineMaintenanceApiClient = RoutineMaintenanceApiClient();

  final String _vehicleObjectId;
  RoutineMaintenanceService(this._vehicleObjectId);
  late final _routineMaintenanceDataProvider =
      RoutineMaintenanceDataProvider(_vehicleObjectId);

  Future<void> createRoutineMaintenance({
    required String title,
    required int periodicity,
    required int engineHoursValue,
    required String vehicleNode,
  }) async {
    final routineMaintenanceId =
        await _routineMaintenanceApiClient.saveRoutineMaintenance(
      title: title,
      periodicity: periodicity,
      engineHoursValue: engineHoursValue,
      vehicleNode: vehicleNode,
      vehicleObjectId: _vehicleObjectId,
    );
    if (routineMaintenanceId != null) {
      final routineMaintenance = RoutineMaintenance(
        objectId: routineMaintenanceId,
        title: title,
        periodicity: periodicity,
        engineHoursValue: engineHoursValue,
        vehicleNode: vehicleNode,
      );
      await _routineMaintenanceDataProvider
          .putRoutineMaintenanceToHive(routineMaintenance);
    }
  }

  Future<List<RoutineMaintenance>>
      downloadVehicleRoutineMaintenanceList() async {
    final vehicleRoutineMaintenancesFromServer =
        await _routineMaintenanceApiClient.getVehicleRoutineMaintenanceList(
            vehicleObjectId: _vehicleObjectId);
    await _routineMaintenanceDataProvider
        .deleteUnnecessaryRoutineMaintenancesFromHive(
            vehicleRoutineMaintenancesFromServer);
    for (var routineMaintenance in vehicleRoutineMaintenancesFromServer) {
      await _routineMaintenanceDataProvider
          .putRoutineMaintenanceToHive(routineMaintenance);
    }
    return await getVehicleRoutineMaintenancesFromHive();
  }

  Future<List<RoutineMaintenance>>
      getVehicleRoutineMaintenancesFromHive() async {
    final vehicleRoutineMaintenances = await _routineMaintenanceDataProvider
        .getRoutineMaintenancesListFromHive();
    vehicleRoutineMaintenances
        .sort((a, b) => a.remainEngineHours.compareTo(b.remainEngineHours));
    return vehicleRoutineMaintenances;
  }

  Future<RoutineMaintenanceHoursInfo?>
      getVehicleRoutineMaintenanceHoursInfo() async {
    final routineMaintenances = await getVehicleRoutineMaintenancesFromHive();
    routineMaintenances
        .sort((a, b) => a.remainEngineHours.compareTo(b.remainEngineHours));
    if (routineMaintenances.isNotEmpty) {
      final mostPriority = routineMaintenances[0];
      return RoutineMaintenanceHoursInfo(
        periodicity: mostPriority.periodicity,
        engineHoursValue: mostPriority.engineHoursValue,
      );
    }
  }

  Future<void> resetEngineHoursValue({
    required String routineMaintenanceObjectId,
  }) async {
    final routineMaintenanceId =
        await _routineMaintenanceApiClient.updateRoutineMaintenance(
      objectId: routineMaintenanceObjectId,
      engineHoursValue: 0,
    );
    if (routineMaintenanceId != null) {
      await _routineMaintenanceDataProvider.updateRoutineMaintenanceInHive(
          routineMaintenanceId: routineMaintenanceId, engineHoursValue: 0);
    }
  }

  Future<void> addEngineHoursToVehicleRoutineMaintenances({
    required int additionalEngineHours,
  }) async {
    final routineMaintenaces = await _routineMaintenanceDataProvider
        .getRoutineMaintenancesListFromHive();
    for (var routineMaintenance in routineMaintenaces) {
      final currentEngineHours = (await _routineMaintenanceDataProvider
              .getRoutineMaintenanceFromHive(routineMaintenance.objectId))
          ?.engineHoursValue;
      if (currentEngineHours == null) return;
      final newEngineHours = currentEngineHours + additionalEngineHours;
      final routineMaintenanceId =
          await _routineMaintenanceApiClient.updateRoutineMaintenance(
        objectId: routineMaintenance.objectId,
        engineHoursValue: newEngineHours,
      );
      if (routineMaintenanceId != null) {
        await _routineMaintenanceDataProvider.updateRoutineMaintenanceInHive(
            routineMaintenanceId: routineMaintenanceId,
            engineHoursValue: newEngineHours);
      }
    }
  }

  Future<Stream<BoxEvent>> getRoutineMaintenanceStream() async {
    final routineMaintenanceStream =
        await _routineMaintenanceDataProvider.getRoutineMaintenanceStream();
    return routineMaintenanceStream;
  }

  Future<void> updateRoutineMaintenance({
    required String objectId,
    String? title,
    int? periodicity,
    int? engineHoursValue,
    String? vehicleNode,
  }) async {
    final routineMaintenanceObjectId =
        await _routineMaintenanceApiClient.updateRoutineMaintenance(
      objectId: objectId,
      title: title,
      periodicity: periodicity,
      engineHoursValue: engineHoursValue,
      vehicleNode: vehicleNode,
    );
    if (routineMaintenanceObjectId != null) {
      await _routineMaintenanceDataProvider.updateRoutineMaintenanceInHive(
        routineMaintenanceId: routineMaintenanceObjectId,
        title: title,
        periodicity: periodicity,
        engineHoursValue: engineHoursValue,
        vehicleNode: vehicleNode,
      );
    }
  }

  Future<void> deleteRoutineMaintenance(String routineMaintenanceId) async {
    await _routineMaintenanceApiClient
        .deleteRoutineMaintenance(routineMaintenanceId);
    await _routineMaintenanceDataProvider
        .deleteRoutineMaintenanceFromHive(routineMaintenanceId);
  }

  Future<void> dispose() async {
    await _routineMaintenanceDataProvider.dispose();
  }
}
