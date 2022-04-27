import 'dart:io';

import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class VehicleApiClient {
  String _vehicleObjectId = '';
  String get vehicleObjectId => _vehicleObjectId;

  Future<void> saveVehicleToDatabase({
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

    if (apiResponse.success && apiResponse.results != null) {
      _vehicleObjectId = vehicle.objectId!;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
  }

  Future<List<Vehicle>> getAllVehicles() async {
    // final ParseCloudFunction function = ParseCloudFunction('getListBreakages');
    // final ParseResponse parseResponse = await function.execute();
    // if (parseResponse.success && parseResponse.result != null) {
    //   print(parseResponse.result);
    //   //Use fromJson method to convert map in ParseObject
    //   // print(ParseObject('ToDo').fromJson(todo));

    // }

    List<Vehicle> vehiclesList = [];

    QueryBuilder<ParseObject> queryVehicle =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.vehicle))
          ..orderByAscending('model')
          ..includeObject(['photo']);

    final ParseResponse apiResponse = await queryVehicle.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var result in apiResponse.results!) {
        final vehicleParseObject = result as ParseObject;
        final vehicle = Vehicle.getVehiclefromParseObject(vehicleParseObject);
        vehiclesList.add(vehicle);
      }
      return vehiclesList;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
    // final ParseResponse responseRecommendation =
    //     await queryRecommendation.query();

    // if (responseRecommendation.success &&
    //     responseRecommendation.results != null) {
    //   final recommendation =
    //       (responseRecommendation.results?.first) as ParseObject;
    // }

    // QueryBuilder<ParseObject> queryAuthors =
    //     QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
    //       ..whereRelatedTo('photos', 'Recommendation', 'nUDxAWJ8mw');

    // final ParseResponse responseAuthors = await queryAuthors.query();

    // if (responseAuthors.success && responseAuthors.results != null) {
    //   final bookAuthors = responseAuthors.results;
    //   // .map((e) => (e as ParseObject).get<String>('name'))
    //   // .toList();
    // }
  }
}
