import 'package:autospectechnics/domain/data_providers/vehicle_building_object_data_provider.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';

class VehicleBuildingObjectService {
  final _vehicleBuildingObjectDataProvider =
      VehicleBuildingObjectDataProvider();

  Future<List<VehicleBuildingObject>> getVehicleBuildingObjectListFromHive(
      String buildingObjectId) async {
    return await _vehicleBuildingObjectDataProvider
        .getVehicleBuildingObjectListFromHive(buildingObjectId);
  }
}
