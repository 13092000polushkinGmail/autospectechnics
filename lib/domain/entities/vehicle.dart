import 'package:parse_server_sdk/parse_server_sdk.dart';

class Vehicle {
  final String objectId;
  final String model;
  final int breakageDangerLevel;
  final RoutineMaintenanceHoursInfo? hoursInfo;
  final String? imageURL;
  Vehicle({
    required this.objectId,
    required this.model,
    required this.breakageDangerLevel,
    required this.hoursInfo,
    this.imageURL,
  });

  static Vehicle getVehicle({
    required ParseObject vehicleParseObject,
    required int breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
  }) {
    final objectId = vehicleParseObject.objectId!;
    final model = vehicleParseObject.get<String>('model')!;
    final imageParseObject = vehicleParseObject.get<ParseObject>('photo');
    String? fileURL;
    if (imageParseObject != null) {
      final imageFile = imageParseObject.get<ParseFileBase>('file')!;
      fileURL = imageFile.url!;
    }
    return Vehicle(
      objectId: objectId,
      model: model,
      breakageDangerLevel: breakageDangerLevel,
      imageURL: fileURL,
      hoursInfo: hoursInfo,
    );
  }
}

class RoutineMaintenanceHoursInfo {
  final int periodicity;
  final int engineHoursValue;
  RoutineMaintenanceHoursInfo({
    required this.periodicity,
    required this.engineHoursValue,
  });

  int get remainEngineHours => periodicity - engineHoursValue;
}
