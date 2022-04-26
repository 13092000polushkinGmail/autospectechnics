import 'dart:io';

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
}
