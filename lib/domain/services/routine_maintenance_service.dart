import 'package:autospectechnics/domain/api_clients/routine_maintenance_api_client.dart';
import 'package:autospectechnics/domain/data_providers/routine_maintenance_data_provider.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';

class RoutineMaintenanceService {
  final _routineMaintenanceApiClient = RoutineMaintenanceApiClient();
  final _routineMaintenanceDataProvider = RoutineMaintenanceDataProvider();

  Future<List<RoutineMaintenance>> downloadVehicleRoutineMaintenanceList({
    required String vehicleObjectId,
  }) async {
    final routineMaintenanceList = await _routineMaintenanceApiClient
        .getVehicleRoutineMaintenanceList(vehicleObjectId: vehicleObjectId);
    await _routineMaintenanceDataProvider
        .deleteAllRoutineMaintenancesFromHive(vehicleObjectId);
    for (var routineMaintenance in routineMaintenanceList) {
      await _routineMaintenanceDataProvider.putRoutineMaintenanceToHive(
          routineMaintenance, vehicleObjectId);
    }
    return await getVehicleRoutineMaintenancesFromHive(
        vehicleObjectId: vehicleObjectId);
  }

  Future<List<RoutineMaintenance>> getVehicleRoutineMaintenancesFromHive({
    required String vehicleObjectId,
  }) async {
    final vehicleRoutineMaintenances = await _routineMaintenanceDataProvider
        .getRoutineMaintenancesListFromHive(vehicleObjectId);
    vehicleRoutineMaintenances
        .sort((a, b) => a.remainEngineHours.compareTo(b.remainEngineHours));
    return vehicleRoutineMaintenances;
  }

  Future<void> resetEngineHoursValue({
    required String routineMaintenanceObjectId,
  }) async {
    await _routineMaintenanceApiClient.updateRoutineMaintenance(
      objectId: routineMaintenanceObjectId,
      engineHoursValue: 0,
    );
  }
}
