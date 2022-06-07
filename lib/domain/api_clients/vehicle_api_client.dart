import 'dart:async';

import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class VehicleApiClient {
  Future<String?> saveVehicleToDatabase({
    required String model,
    required int mileage,
    required int vehicleType,
    String? licensePlate,
    String? description,
  }) async {
    var vehicle = ParseObject(ParseObjectNames.vehicle);
    vehicle.set('model', model);
    vehicle.set('mileage', mileage);
    vehicle.set('vehicleType', vehicleType);

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

  Future<String?> updateVehicle({
    required String objectId,
    String? model,
    int? mileage,
    int? vehicleType,
    String? licensePlate,
    String? description,
  }) async {
    var vehicle = ParseObject(ParseObjectNames.vehicle);
    vehicle.objectId = objectId;

    if (model != null) {
      vehicle.set('model', model);
    }
    if (mileage != null) {
      vehicle.set('mileage', mileage);
    }
    if (vehicleType != null) {
      vehicle.set('vehicleType', vehicleType);
    }
    if (licensePlate != null) {
      vehicle.set('licensePlate', licensePlate);
    }
    if (description != null) {
      vehicle.set('description', description);
    }

    if (model != null ||
        mileage != null ||
        vehicleType != null ||
        licensePlate != null ||
        description != null) {
      final ParseResponse apiResponse = await vehicle.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
    return vehicle.objectId;
  }

  Future<void> deleteVehicleFromDatabase(String vehicleId) async {
    final parseVehicle = ParseObject(ParseObjectNames.vehicle)
      ..objectId = vehicleId;

    final ParseResponse apiResponse = await parseVehicle.delete();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<Vehicle>> getVehiclesList() async {
    List<Vehicle> vehiclesList = [];

    QueryBuilder<ParseObject> queryVehicle =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.vehicle))
          ..orderByAscending('model')
          ..includeObject(['photo']);

    final ParseResponse apiResponse = await queryVehicle.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      for (var result in apiResponse.results!) {
        final vehicleParseObject = result as ParseObject;

        final breakageDangerLevel =
            await _getBreakageLevel(vehicleParseObject.objectId!);

        final vehicle = Vehicle.getVehicle(
          vehicleParseObject: vehicleParseObject,
          breakageDangerLevel: breakageDangerLevel,
        );
        vehiclesList.add(vehicle);
      }
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
}
