import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RoutineMaintenanceApiClient {
  Future<String?> saveRoutineMaintenance({
    required String title,
    required int periodicity,
    required int engineHoursValue,
    required String vehicleNode,
    required String vehicleObjectId,
  }) async {
    var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
    routineMaintenance.set(RoutineMaintenanceFieldNames.title, title);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.periodicity, periodicity);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.engineHoursValue, engineHoursValue);
    routineMaintenance.set(
        RoutineMaintenanceFieldNames.vehicleNode, vehicleNode);
    routineMaintenance.set(
        'vehicle',
        (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
            .toPointer());

    final ParseResponse apiResponse = await routineMaintenance.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return routineMaintenance.objectId;
  }

  Future<String?> updateRoutineMaintenance({
    required String objectId,
    String? title,
    int? periodicity,
    int? engineHoursValue,
    String? vehicleNode,
  }) async {
    var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
    routineMaintenance.objectId = objectId;

    if (title != null) {
      routineMaintenance.set('title', title);
    }

    if (periodicity != null) {
      routineMaintenance.set('periodicity', periodicity);
    }

    if (engineHoursValue != null) {
      routineMaintenance.set('engineHoursValue', engineHoursValue);
    }

    if (vehicleNode != null) {
      routineMaintenance.set('vehicleNode', vehicleNode);
    }

    if (title != null ||
        vehicleNode != null ||
        periodicity != null ||
        engineHoursValue != null) {
      final ParseResponse apiResponse = await routineMaintenance.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
    return routineMaintenance.objectId;
  }

  Future<void> deleteRoutineMaintenance(String routineMaintenanceId) async {
    final parseRoutineMaintenance =
        ParseObject(ParseObjectNames.routineMaintenance)
          ..objectId = routineMaintenanceId;

    final ParseResponse apiResponse = await parseRoutineMaintenance.delete();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<RoutineMaintenance>> getVehicleRoutineMaintenanceList({
    required String vehicleObjectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(ParseObjectNames.routineMaintenance))
      ..whereEqualTo(
          'vehicle',
          (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
              .toPointer());

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final List<RoutineMaintenance> routineMaintenanceList = [];

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      for (var element in apiResponseResults) {
        final routineMaintenanceObject = element as ParseObject;

        final routineMaintenance = RoutineMaintenance.getRoutineMaintenance(
          routineMaintenanceObject: routineMaintenanceObject,
        );
        routineMaintenanceList.add(routineMaintenance);
      }
    }
    return routineMaintenanceList;
  }
}

abstract class RoutineMaintenanceFieldNames {
  static const objectId = 'objectId';
  static const title = 'title';
  static const periodicity = 'periodicity';
  static const engineHoursValue = 'engineHoursValue';
  static const vehicleNode = 'vehicleNode';
}
