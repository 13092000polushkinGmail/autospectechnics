import 'package:hive/hive.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
part 'vehicle_building_object.g.dart';

@HiveType(typeId: 5)
class VehicleBuildingObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String buildingObjectId;
  @HiveField(2)
  final String vehicleId;
  @HiveField(3)
  final int requiredEngineHours;
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
}
