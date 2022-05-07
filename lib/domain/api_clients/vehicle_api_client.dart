import 'dart:async';

import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/entities/vehicle_details.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class VehicleApiClient {
  Future<String?> saveVehicleToDatabase({
    required String model,
    required int mileage,
    String? licensePlate,
    String? description,
  }) async {
    var vehicle = ParseObject(ParseObjectNames.vehicle);
    vehicle.set('model', model);
    vehicle.set('mileage', mileage);

    if (licensePlate != null) {
      vehicle.set('licensePlate', licensePlate);
    }

    if (description != null) {
      vehicle.set('description', description);
    }

    final ParseResponse apiResponse = await vehicle.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return vehicle.objectId;
  }

  Future<List<Vehicle>> getVehiclesList() async {
    final stopwatch = Stopwatch()..start();

    List<Vehicle> vehiclesList = [];

    QueryBuilder<ParseObject> queryVehicle =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.vehicle))
          ..keysToReturn(['model', 'photo'])
          ..orderByAscending('model')
          ..includeObject(['photo']);

    final ParseResponse apiResponse = await queryVehicle.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      for (var result in apiResponse.results!) {
        final vehicleParseObject = result as ParseObject;

        final breakageDangerLevel =
            await _getBreakageLevel(vehicleParseObject.objectId!);

        final routineMaintenanceHoursInfo =
            await _getRemainEngineHours(vehicleParseObject.objectId!);

        final vehicle = Vehicle.getVehicle(
          vehicleParseObject: vehicleParseObject,
          breakageDangerLevel: breakageDangerLevel,
          hoursInfo: routineMaintenanceHoursInfo,
        );
        vehiclesList.add(vehicle);
      }
      stopwatch.stop();
      print('EXECUTED in ${stopwatch.elapsed}');
      return vehiclesList;
    } else {
      throw ApiClientException(type: ApiClientExceptionType.emptyResponse);
    }
  }

  Future<int> _getBreakageLevel(String vehicleObjectId) async {
    //Рабочий, но не до конца протестированный вариант с исполнением кода в Cloud Code, выигрыша по времени не дает поэтому убрал как менее понятный
    // final ParseCloudFunction function = ParseCloudFunction('getBreakageLevel');
    // final Map<String, dynamic> params = <String, dynamic>{
    //   'vehicleObjectId': vehicleObjectId,
    // };
    // final ParseResponse apiResponse =
    //     await function.execute(parameters: params);
    // ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    // if (apiResponse.result != null) {
    //   final result = apiResponse.result as Map<String, dynamic>;
    //   if (result.isEmpty) return -1;
    //   final level = apiResponse.result['dangerLevel'] as int;
    //   return apiResponse.result['dangerLevel'] as int;
    // } else {
    //   return -1;
    // }

    QueryBuilder<ParseObject> queryBreakage =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.breakage))
          ..keysToReturn(['dangerLevel'])
          ..whereEqualTo(
              'vehicle',
              (ParseObject(ParseObjectNames.vehicle)
                    ..objectId = vehicleObjectId)
                  .toPointer())
          ..whereEqualTo("isFixed", false)
          ..orderByDescending("dangerLevel")
          ..setLimit(1);

    final apiResponse = await queryBreakage.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      final breakage = apiResponse.results!.first as ParseObject;
      return breakage.get<int>('dangerLevel')!;
    } else {
      //TODO Подумать как лучше показывать, что нет неисправностей
      return -1;
    }
  }

  Future<RoutineMaintenanceHoursInfo?> _getRemainEngineHours(
    String vehicleObjectId,
  ) async {
    QueryBuilder<ParseObject> queryRoutineMaintenance = QueryBuilder<
        ParseObject>(ParseObject(ParseObjectNames.routineMaintenance))
      ..keysToReturn(['periodicity', 'engineHoursValue'])
      ..whereEqualTo(
          'vehicle',
          (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
              .toPointer());

    final apiResponse = await queryRoutineMaintenance.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    //TODO Пока колхозный метод, который не сохраняет полученные данные, а потом будет грузить их по новой
    RoutineMaintenanceHoursInfo minRemainEngineHours =
        RoutineMaintenanceHoursInfo(periodicity: 50000, engineHoursValue: 0);
    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      for (var element in apiResponseResults) {
        final routineMaintenance = element as ParseObject;
        final engineHoursValue =
            routineMaintenance.get<int>('engineHoursValue');
        final periodicity = routineMaintenance.get<int>('periodicity');
        if (engineHoursValue != null && periodicity != null) {
          final hoursInfo = RoutineMaintenanceHoursInfo(
              periodicity: periodicity, engineHoursValue: engineHoursValue);
          if (hoursInfo.remainEngineHours <
              minRemainEngineHours.remainEngineHours) {
            minRemainEngineHours = hoursInfo;
          }
        }
      }
      return minRemainEngineHours;
    }
  }

  Future<VehicleDetails?> getVehicleDetails({
    required String vehicleObjectId,
  }) async {
    QueryBuilder<ParseObject> queryVehicleDetails =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.vehicle))
          ..whereEqualTo('objectId', vehicleObjectId)
          ..includeObject(['photo']);

    final apiResponse = await queryVehicleDetails.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      final vehicleObject = apiResponse.results!.first as ParseObject;

      final vehicleDetails =
          VehicleDetails.getVehicleDetails(vehicleObject: vehicleObject);
      return vehicleDetails;
    }
  }
}
