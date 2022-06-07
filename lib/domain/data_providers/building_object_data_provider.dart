import 'package:hive/hive.dart';

import 'package:autospectechnics/domain/data_providers/box_manager.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';

class BuildingObjectDataProvider {
  late Future<Box<BuildingObject>> _futureBox;
  BuildingObjectDataProvider() {
    _futureBox = BoxManager.instance.openBox(
      name: 'building_objects_box',
      typeId: 4,
      adapter: BuildingObjectAdapter(),
    );
  }

  Future<Stream<BoxEvent>> getBuildingObjectStream() async {
    final box = await _futureBox;
    final buildingObjectStream = box.watch();
    return buildingObjectStream;
  }

  Future<void> putBuildingObjectToHive(BuildingObject buildingObject) async {
    final box = await _futureBox;
    final buildingObjectFromHive = box.get(buildingObject.objectId);
    if (buildingObjectFromHive == null ||
        buildingObjectFromHive != buildingObject) {
      await box.put(buildingObject.objectId, buildingObject);
    }
  }

  Future<void> updateBuildingObjectInHive({
    required String buildingObjectId,
    String? title,
    DateTime? startDate,
    DateTime? finishDate,
    String? description,
    bool? isCompleted,
    Map<String, String>? imagesIdUrl,
  }) async {
    final box = await _futureBox;
    final buildingObject = box.get(buildingObjectId);
    if (buildingObject != null) {
      buildingObject.updateBuildingObject(
        title,
        startDate,
        finishDate,
        description,
        isCompleted,
        imagesIdUrl,
      );
      await buildingObject.save();
    }
  }

  Future<void> deleteBuildingObjectFromHive(String buildingObjectId) async {
    final box = await _futureBox;
    await box.delete(buildingObjectId);
  }

  Future<List<BuildingObject>> getBuildingObjectListFromHive() async {
    final box = await _futureBox;
    final list = box.values.toList();
    return list;
  }

  Future<BuildingObject?> getBuildingObjectFromHive(
      String buildingObjectId) async {
    final box = await _futureBox;
    final buildingObject = box.get(buildingObjectId);
    return buildingObject;
  }

  Future<void> deleteAllUnnecessaryBuildingObjectsFromHive(
      List<BuildingObject> buildingObjectsFromServer) async {
    final box = await _futureBox;
    final keysToDelete = box.keys.toList();
    for (var buildingObject in buildingObjectsFromServer) {
      if (keysToDelete.contains(buildingObject.objectId)) {
        keysToDelete.remove(buildingObject.objectId);
      }
    }
    for (var key in keysToDelete) {
      box.delete(key);
      final buildingObjectId = key.toString().toLowerCase();
      Hive.deleteBoxFromDisk('vehicle_building_object_box_$buildingObjectId');
    }
  }

  Future<void> dispose() async {
    final box = await _futureBox;
    await BoxManager.instance.closeBox(box);
  }
}
