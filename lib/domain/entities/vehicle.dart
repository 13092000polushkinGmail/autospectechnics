import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 2)
class Vehicle extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  String model;
  @HiveField(2)
  int mileage;
  @HiveField(8)
  int vehicleType;
  @HiveField(3)
  String? licensePlate;
  @HiveField(4)
  String? description;
  @HiveField(5)
  int breakageDangerLevel;
  @HiveField(6)
  RoutineMaintenanceHoursInfo? hoursInfo;
  @HiveField(7)
  Map<String, String> imageIdUrl;
  Vehicle({
    required this.objectId,
    required this.model,
    required this.mileage,
    required this.vehicleType,
    this.licensePlate,
    this.description,
    required this.breakageDangerLevel,
    this.hoursInfo,
    required this.imageIdUrl,
  });

  static Vehicle getVehicle({
    required ParseObject vehicleParseObject,
    required int breakageDangerLevel,
  }) {
    final objectId = vehicleParseObject.objectId ?? 'Нет objectId';
    final model =
        vehicleParseObject.get<String>('model') ?? 'Марка и модель неизвестны';
    final mileage = vehicleParseObject.get<int>('mileage') ?? 0;
    final vehicleType = vehicleParseObject.get<int>('vehicleType') ?? 8;
    final licensePlate = vehicleParseObject.get<String>('licensePlate');
    final description = vehicleParseObject.get<String>('description');
    final imageParseObject = vehicleParseObject.get<ParseObject>('photo');
    Map<String, String> imageIdUrl = {};
    if (imageParseObject != null) {
      final imageId = imageParseObject.objectId;
      String? imageURL;
      final imageFile = imageParseObject.get<ParseFileBase>('file');
      imageURL = imageFile?.url;
      if (imageId != null && imageURL != null) {
        imageIdUrl[imageId] = imageURL;
      }
    }
    return Vehicle(
      objectId: objectId,
      model: model,
      vehicleType: vehicleType,
      breakageDangerLevel: breakageDangerLevel,
      mileage: mileage,
      licensePlate: licensePlate,
      description: description,
      imageIdUrl: imageIdUrl,
    );
  }

  void updateVehicle(
    String? model,
    int? mileage,
    int? vehicleType,
    String? licensePlate,
    String? description,
    int? breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
    Map<String, String>? imageIdUrl,
  ) {
    if (model != null) {
      this.model = model;
    }
    if (mileage != null) {
      this.mileage = mileage;
    }
    if (vehicleType != null) {
      this.vehicleType = vehicleType;
    }
    if (licensePlate != null) {
      this.licensePlate = licensePlate;
    }
    if (description != null) {
      this.description = description;
    }
    if (breakageDangerLevel != null) {
      this.breakageDangerLevel = breakageDangerLevel;
    }
    if (hoursInfo != null) {
      this.hoursInfo = hoursInfo;
    }
    if (imageIdUrl != null && imageIdUrl.isNotEmpty) {
      this.imageIdUrl.addAll(imageIdUrl);
    }
  }

  int getVehicleStatusFromRoutineMaintenanceInfo(int requiredEngineHours) {
    int vehicleStatus = -2;
    final remainEngineHours = hoursInfo?.remainEngineHours;
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
    return max(vehicleStatus, breakageDangerLevel);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vehicle &&
        other.objectId == objectId &&
        other.model == model &&
        other.mileage == mileage &&
        other.vehicleType == vehicleType &&
        other.licensePlate == licensePlate &&
        other.description == description &&
        other.breakageDangerLevel == breakageDangerLevel &&
        other.hoursInfo == hoursInfo &&
        mapEquals(other.imageIdUrl, imageIdUrl);
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        model.hashCode ^
        mileage.hashCode ^
        vehicleType.hashCode ^
        licensePlate.hashCode ^
        description.hashCode ^
        breakageDangerLevel.hashCode ^
        hoursInfo.hashCode ^
        imageIdUrl.hashCode;
  }

  Vehicle copyWith({
    String? objectId,
    String? model,
    int? mileage,
    int? vehicleType,
    String? licensePlate,
    String? description,
    int? breakageDangerLevel,
    RoutineMaintenanceHoursInfo? hoursInfo,
    Map<String, String>? imageIdUrl,
  }) {
    return Vehicle(
      objectId: objectId ?? this.objectId,
      model: model ?? this.model,
      mileage: mileage ?? this.mileage,
      vehicleType: vehicleType ?? this.vehicleType,
      licensePlate: licensePlate ?? this.licensePlate,
      description: description ?? this.description,
      breakageDangerLevel: breakageDangerLevel ?? this.breakageDangerLevel,
      hoursInfo: hoursInfo ?? this.hoursInfo?.copyWith(),
      imageIdUrl: imageIdUrl ?? Map<String, String>.from(this.imageIdUrl),
    );
  }
}

@HiveType(typeId: 3)
class RoutineMaintenanceHoursInfo {
  @HiveField(0)
  int periodicity;
  @HiveField(1)
  int engineHoursValue;
  RoutineMaintenanceHoursInfo({
    required this.periodicity,
    required this.engineHoursValue,
  });

  int get remainEngineHours => periodicity - engineHoursValue;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoutineMaintenanceHoursInfo &&
        other.periodicity == periodicity &&
        other.engineHoursValue == engineHoursValue;
  }

  @override
  int get hashCode => periodicity.hashCode ^ engineHoursValue.hashCode;

  RoutineMaintenanceHoursInfo copyWith({
    int? periodicity,
    int? engineHoursValue,
  }) {
    return RoutineMaintenanceHoursInfo(
      periodicity: periodicity ?? this.periodicity,
      engineHoursValue: engineHoursValue ?? this.engineHoursValue,
    );
  }
}
