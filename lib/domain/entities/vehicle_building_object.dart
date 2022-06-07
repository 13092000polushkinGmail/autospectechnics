import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'vehicle_building_object.g.dart';

@HiveType(typeId: 5)
class VehicleBuildingObject extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String buildingObjectId;
  @HiveField(2)
  final String vehicleId;
  @HiveField(3)
  int requiredEngineHours;
  VehicleBuildingObject({
    required this.id,
    required this.buildingObjectId,
    required this.vehicleId,
    required this.requiredEngineHours,
  });

  static VehicleBuildingObject getVehicleBuildingObject({
    required ParseObject vehicleBuildingObject,
  }) {
    final objectId = vehicleBuildingObject.objectId ?? 'Нет objectId';
    final buildingObjectId =
        vehicleBuildingObject.get<ParseObject>('buildingObject')?.objectId ??
            'Нет buildingObjectId';
    final vehicleId =
        vehicleBuildingObject.get<ParseObject>('vehicle')?.objectId ??
            'Нет vehicleId';
    final requiredEngineHours =
        vehicleBuildingObject.get<int>('requiredEngineHours') ?? 0;

    return VehicleBuildingObject(
      id: objectId,
      buildingObjectId: buildingObjectId,
      vehicleId: vehicleId,
      requiredEngineHours: requiredEngineHours,
    );
  }

  void updateVehicleBuildingObject(
    int? requiredEngineHours,
  ) {
    if (requiredEngineHours != null) {
      this.requiredEngineHours = requiredEngineHours;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleBuildingObject &&
        other.id == id &&
        other.buildingObjectId == buildingObjectId &&
        other.vehicleId == vehicleId &&
        other.requiredEngineHours == requiredEngineHours;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        buildingObjectId.hashCode ^
        vehicleId.hashCode ^
        requiredEngineHours.hashCode;
  }
}
