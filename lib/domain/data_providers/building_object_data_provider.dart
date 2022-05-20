import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:hive/hive.dart';

class BuildingObjectDataProvider {
  Future<Box<BuildingObject>> _openBox() async {
    return await BoxManager.instance.openBox(
      name: 'building_objects_box',
      typeId: 4,
      adapter: BuildingObjectAdapter(),
    );
  }

  Future<void> putBuildingObjectToHive(BuildingObject buildingObject) async {
    final box = await _openBox();
    //TODO Если объект существует, нужно сверять с добавляемым, если отличаются менять на новый, если такой же ничего не делать. Это на случай, если подписываться на изменения в box, чтобы лишний раз не обновлять виджет
    await box.put(buildingObject.objectId, buildingObject);
    await BoxManager.instance.closeBox(box);
  }

  Future<List<BuildingObject>> getBuildingObjectListFromHive() async {
    final box = await _openBox();
    final list = box.values.toList();
    await BoxManager.instance.closeBox(box);
    return list;
  }

  Future<BuildingObject?> getBuildingObjectFromHive(String buildingObjectId) async {
    final box = await _openBox();
    final buildingObject = box.get(buildingObjectId);
    await BoxManager.instance.closeBox(box);
    return buildingObject;
  }

  Future<void> deleteAllBuildingObjectsFromHive() async {
    final box = await _openBox();
    await box.clear();
    await BoxManager.instance.closeBox(box);
  }
}
