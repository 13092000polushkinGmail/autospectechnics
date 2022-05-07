import 'package:autospectechnics/domain/api_clients/routine_maintenance_api_client.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';

class RoutineMaintenanceService {
  final _routineMaintenanceApiClient = RoutineMaintenanceApiClient();

  Future<List<RoutineMaintenance>> getVehicleRoutineMaintenanceList({
    required String vehicleObjectId,
  }) async {
    final routineMaintenanceList = await _routineMaintenanceApiClient.getVehicleRoutineMaintenanceList(
        vehicleObjectId: vehicleObjectId);
    routineMaintenanceList.sort((a, b) => a.remainEngineHours.compareTo(b.remainEngineHours));
    return routineMaintenanceList;
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
