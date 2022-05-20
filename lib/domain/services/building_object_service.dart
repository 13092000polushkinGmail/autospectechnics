import 'package:autospectechnics/domain/api_clients/building_object_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/vehicle_building_object_api_client.dart';
import 'package:autospectechnics/domain/data_providers/building_object_data_provider.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_building_object_data_provider.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_data_provider.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class BuildingObjectService {
  final _buildingObjectApiClient = BuildingObjectApiClient();
  final _vehicleBuildingObjectApiClient = VehicleBuildingObjectApiClient();
  final _vehicleBuildingObjectDataProvider =
      VehicleBuildingObjectDataProvider();
  final _vehicleDataProvider = VehicleDataProvider();
  final _buildingObjectDataProvider = BuildingObjectDataProvider();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  Future<void> createBuildingObject({
    required String title,
    required DateTime startDate,
    required DateTime finishDate,
    required String description,
    bool isCompleted = false,
    List<XFile>? imagesList,
    required Map<String, int> vehicleEngineHours,
  }) async {
    final buildingObjectId =
        await _buildingObjectApiClient.saveBuildingObjectToDatabase(
      title: title,
      startDate: startDate,
      finishDate: finishDate,
      description: description,
      isCompleted: isCompleted,
    );
    if (buildingObjectId != null) {
      if (vehicleEngineHours.isNotEmpty) {
        final amountPickedVehicles = vehicleEngineHours.length;
        final vehicleIds = vehicleEngineHours.keys.toList();
        final requiredEngineHours = vehicleEngineHours.values.toList();
        for (var i = 0; i < amountPickedVehicles; i++) {
          await _vehicleBuildingObjectApiClient
              .saveVehicleBuildingObjectToDatabase(
                  buildingObjectId: buildingObjectId,
                  vehicleId: vehicleIds[i],
                  requiredEngineHours: requiredEngineHours[i]);
        }
      }
      if (imagesList != null && imagesList.isNotEmpty) {
        final savedImagesObjectIds =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.buildingObject,
          entityObjectId: buildingObjectId,
          imageObjectIdList: savedImagesObjectIds.keys.toList(),
        );
      }
    }
  }

  Future<List<BuildingObject>> downloadBuildingObjects() async {
    final buildingObjectList =
        await _buildingObjectApiClient.getBuildingObjectList();
    await _buildingObjectDataProvider.deleteAllBuildingObjectsFromHive();

    for (var buildingObject in buildingObjectList) {
      await _buildingObjectDataProvider.putBuildingObjectToHive(buildingObject);
      final vehicleBuildingObjectList = await _vehicleBuildingObjectApiClient
          .downloadVehicleBuildingObjectList(buildingObject.objectId);
      await _vehicleBuildingObjectDataProvider
          .deleteAllVehicleBuildingObjectsFromHive(buildingObject.objectId);
      for (var vehicleBuildingObject in vehicleBuildingObjectList) {
        await _vehicleBuildingObjectDataProvider
            .putVehicleBuildingObjectToHive(vehicleBuildingObject);
      }
    }
    return await getBuildingObjectsListFromHive();
  }

  Future<List<BuildingObject>> getBuildingObjectsListFromHive() async {
    final buildingObjectsList =
        await _buildingObjectDataProvider.getBuildingObjectListFromHive();
    return buildingObjectsList;
  }

  Future<BuildingObject?> getBuildingObjectFromHive({
    required String buildingObjectId,
  }) async {
    final buildingObject = await _buildingObjectDataProvider
        .getBuildingObjectFromHive(buildingObjectId);
    return buildingObject;
  }

  Future<int> getBuildingObjectVehicleStatus(String buildingObjectId) async {
    final vehicleBuldingObjectList = await _vehicleBuildingObjectDataProvider
        .getVehicleBuildingObjectListFromHive(buildingObjectId);
    int buildingObjectVehicleStatus = -2;
    for (var vehicleBuldingObject in vehicleBuldingObjectList) {
      final vehicle = await _vehicleDataProvider
          .getVehicleFromHive(vehicleBuldingObject.vehicleId);
      if (vehicle != null) {
        final vehicleStatus = Vehicle.getVehicleDangerLevel(
            vehicle, vehicleBuldingObject.requiredEngineHours);
        if (vehicleStatus > buildingObjectVehicleStatus) {
          buildingObjectVehicleStatus = vehicleStatus;
        }
      }
    }
    return buildingObjectVehicleStatus;
  }
}
