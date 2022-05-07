import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RoutineMaintenanceApiClient {
  //TODO: сделать обработку ошибок, убрать принты и как-то сообщать пользователю об ошибке или успехе

  // Future<void> saveRoutineMaintenance({
  //   required String title,
  //   required int periodicity,
  //   required int engineHoursValue,
  //   required String vehicleNode,
  // }) async {
  //   var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
  //   routineMaintenance.set(RoutineMaintenanceFieldNames.title, title);
  //   routineMaintenance.set(
  //       RoutineMaintenanceFieldNames.periodicity, periodicity);
  //   routineMaintenance.set(
  //       RoutineMaintenanceFieldNames.engineHoursValue, engineHoursValue);
  //   routineMaintenance.set(
  //       RoutineMaintenanceFieldNames.vehicleNode, vehicleNode);

  //   final ParseResponse apiResponse = await routineMaintenance.save();

  //   if (apiResponse.success && apiResponse.results != null) {
  //     print('Топчик');
  //   } else if (apiResponse.error?.exception is SocketException) {
  //     print('Проверьте подключение к интернету');
  //   } else {
  //     print('Нет заказов');
  //   }
  // }

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

  Future<void> updateRoutineMaintenance({
    required String objectId,
    String? title,
    int? periodicity,
    int? engineHoursValue,
    String? vehicleNode,
  }) async {
    var routineMaintenance = ParseObject(ParseObjectNames.routineMaintenance);
    routineMaintenance.objectId = objectId;

    if (title != null) {
      routineMaintenance.set(RoutineMaintenanceFieldNames.title, title);
    }

    if (periodicity != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.periodicity, periodicity);
    }

    if (engineHoursValue != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.engineHoursValue, engineHoursValue);
    }

    if (vehicleNode != null) {
      routineMaintenance.set(
          RoutineMaintenanceFieldNames.vehicleNode, vehicleNode);
    }

    final ParseResponse apiResponse = await routineMaintenance.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }
}

abstract class RoutineMaintenanceFieldNames {
  static const objectId = 'objectId';
  static const title = 'title';
  static const periodicity = 'periodicity';
  static const engineHoursValue = 'engineHoursValue';
  static const vehicleNode = 'vehicleNode';
}
