import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class VehicleBuildingObjectApiClient {
  Future<void> saveVehicleBuildingObjectToDatabase({
    required String buildingObjectId,
    required String vehicleId,
    required int requiredEngineHours,
  }) async {
    var vehicleBuildingObject =
        ParseObject(ParseObjectNames.vehicleBuildingObject);
    vehicleBuildingObject.set(
        'buildingObject',
        (ParseObject(ParseObjectNames.buildingObject)
              ..objectId = buildingObjectId)
            .toPointer());
    vehicleBuildingObject.set(
        'vehicle',
        (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleId)
            .toPointer());
    vehicleBuildingObject.set('requiredEngineHours', requiredEngineHours);

    final ParseResponse apiResponse = await vehicleBuildingObject.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<VehicleBuildingObject>> downloadVehicleBuildingObjectList(
    String buildingObjectId,
  ) async {
    List<VehicleBuildingObject> vehicleBuildingObjectList = [];

    QueryBuilder<ParseObject> queryVehicleBuildingObject = QueryBuilder<
        ParseObject>(ParseObject(ParseObjectNames.vehicleBuildingObject))
      ..whereEqualTo(
        'buildingObject',
        (ParseObject(ParseObjectNames.buildingObject)
              ..objectId = buildingObjectId)
            .toPointer(),
      );

    final ParseResponse apiResponse = await queryVehicleBuildingObject.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      for (var result in apiResponse.results!) {
        final vehicleBuildingObjectParse = result as ParseObject;

        final vehicleBuildingObject =
            VehicleBuildingObject.getVehicleBuildingObject(
                vehicleBuildingObject: vehicleBuildingObjectParse);
        vehicleBuildingObjectList.add(vehicleBuildingObject);
      }
    }
    return vehicleBuildingObjectList;
  }
}
