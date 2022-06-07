import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';
import 'package:hive/hive.dart';

class VehicleBuildingObjectDataProvider {
  late Future<Box<VehicleBuildingObject>> _futureBox;
  final String _buildingObjectId;
  VehicleBuildingObjectDataProvider(this._buildingObjectId) {
    _futureBox = BoxManager.instance.openBox(
      name: 'vehicle_building_object_box_$_buildingObjectId',
      typeId: 5,
      adapter: VehicleBuildingObjectAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getVehicleBuildingObjectStream() async {
    final box = await _futureBox;
    final vehicleBuildingObjectStream = box.watch();
    return vehicleBuildingObjectStream;
  }

  Future<void> putVehicleBuildingObjectToHive(
      VehicleBuildingObject vehicleBuildingObject) async {
    final box = await _futureBox;
    final vehicleBuildingObjectFromHive = box.get(vehicleBuildingObject.id);
    if (vehicleBuildingObjectFromHive == null ||
        vehicleBuildingObject != vehicleBuildingObject) {
      await box.put(vehicleBuildingObject.id, vehicleBuildingObject);
    }
  }

  // Future<void> updateVehicleBuildingObjectInHive({
  //   required String vehicleBuildingObjectId,
  //   int? requiredEngineHours,
  // }) async {
  //   final box = await _futureBox;
  //   final vehicleBuildingObject = box.get(vehicleBuildingObjectId);
  //   if (vehicleBuildingObject != null) {
  //     vehicleBuildingObject.updateVehicleBuildingObject(
  //       requiredEngineHours,
  //     );
  //     await vehicleBuildingObject.save();
  //   }
  // }

  Future<void> deleteVehicleBuildingObjectsOfBuildingObjectFromHive() async {
    final box = await _futureBox;
    await box.clear();
  }

  Future<List<VehicleBuildingObject>>
      getVehicleBuildingObjectListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<void> deleteUnnecessaryVehicleBuildingObjectsFromHive(
      List<VehicleBuildingObject> vehicleBuildingObjectsFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var vehicleBuildingObject in vehicleBuildingObjectsFromServer) {
      if (keysToDelete.contains(vehicleBuildingObject.id)) {
        keysToDelete.remove(vehicleBuildingObject.id);
      }
    }
    box.deleteAll(keysToDelete);
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
