import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';
import 'package:hive/hive.dart';

class VehicleBuildingObjectDataProvider {
  Future<Box<VehicleBuildingObject>> _openBox(String buildingObjectId) async {
    return await BoxManager.instance.openBox(
      name: 'vehicle_building_object_box_$buildingObjectId',
      typeId: 5,
      adapter: VehicleBuildingObjectAdapter(),
    );
  }

  Future<void> putVehicleBuildingObjectToHive(
      VehicleBuildingObject vehicleBuildingObject) async {
    final box = await _openBox(vehicleBuildingObject.buildingObjectId);
    //TODO Если объект существует, нужно сверять с добавляемым, если отличаются менять на новый, если такой же ничего не делать. Это на случай, если подписываться на изменения в box, чтобы лишний раз не обновлять виджет
    await box.put(vehicleBuildingObject.id, vehicleBuildingObject);
    await BoxManager.instance.closeBox(box);
  }

  Future<List<VehicleBuildingObject>> getVehicleBuildingObjectListFromHive(
      String buildingObjectId) async {
    final box = await _openBox(buildingObjectId);
    final list = box.values
        .map((VehicleBuildingObject vehicleBuildingObject) =>
            vehicleBuildingObject)
        .toList();
    await BoxManager.instance.closeBox(box);
    return list;
  }

  Future<void> deleteAllVehicleBuildingObjectsFromHive(String buildingObjectId) async {
    final box = await _openBox(buildingObjectId);
    await box.clear();
    await BoxManager.instance.closeBox(box);
  }
}
