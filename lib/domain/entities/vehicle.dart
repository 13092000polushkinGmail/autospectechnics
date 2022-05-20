import 'dart:math';

import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 2)
class Vehicle {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  final String model;
  @HiveField(2)
  final int mileage;
  @HiveField(3)
  final String? licensePlate;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final int breakageDangerLevel;
  @HiveField(6)
  final RoutineMaintenanceHoursInfo? hoursInfo;
  @HiveField(7)
  final String? imageURL;
  Vehicle({
    required this.objectId,
    required this.model,
    required this.mileage,
    this.licensePlate,
    this.description,
    required this.breakageDangerLevel,
    required this.hoursInfo,
    this.imageURL,
  });

  static Vehicle getVehicle({
    required ParseObject vehicleParseObject,
    required int breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
  }) {
    final objectId = vehicleParseObject.objectId ?? 'Нет objectId';
    final model =
        vehicleParseObject.get<String>('model') ?? 'Марка и модель неизвестны';
    final mileage = vehicleParseObject.get<int>('mileage') ?? 0;
    final licensePlate = vehicleParseObject.get<String>('licensePlate');
    final description = vehicleParseObject.get<String>('description');
    final imageParseObject = vehicleParseObject.get<ParseObject>('photo');
    String? imageURL;
    if (imageParseObject != null) {
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
    }
    return Vehicle(
      objectId: objectId,
      model: model,
      breakageDangerLevel: breakageDangerLevel,
      hoursInfo: hoursInfo,
      imageURL: imageURL,
      mileage: mileage,
      licensePlate: licensePlate,
      description: description,
    );
  }

  static int getVehicleDangerLevel(Vehicle vehicle, int requiredEngineHours) {
    int vehicleStatus = -2;
    final remainEngineHours = vehicle.hoursInfo?.remainEngineHours;
    if (remainEngineHours != null) {
      final readyProportion = remainEngineHours / requiredEngineHours;
      if (readyProportion < 0.75) {
        vehicleStatus = 1;
      } else if (0.75 <= readyProportion && readyProportion <= 1.25) {
        vehicleStatus = 0;
      } else {
        vehicleStatus = -1;
      }
    }
    return max(vehicleStatus, vehicle.breakageDangerLevel);
  }
}

@HiveType(typeId: 3)
class RoutineMaintenanceHoursInfo {
  @HiveField(0)
  final int periodicity;
  @HiveField(1)
  final int engineHoursValue;
  RoutineMaintenanceHoursInfo({
    required this.periodicity,
    required this.engineHoursValue,
  });

  int get remainEngineHours => periodicity - engineHoursValue;
}
