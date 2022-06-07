import 'package:autospectechnics/domain/api_clients/building_object_api_client.dart';
import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/vehicle_building_object_api_client.dart';
import 'package:autospectechnics/domain/data_providers/building_object_data_provider.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_building_object_data_provider.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_data_provider.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class BuildingObjectService {
  final _buildingObjectApiClient = BuildingObjectApiClient();
  final _vehicleBuildingObjectApiClient = VehicleBuildingObjectApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  final _vehicleDataProvider = VehicleDataProvider();
  final _buildingObjectDataProvider = BuildingObjectDataProvider();

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
    Map<String, String> savedImagesIdUrl = {};
    if (buildingObjectId != null) {
      if (vehicleEngineHours.isNotEmpty) {
        final amountPickedVehicles = vehicleEngineHours.length;
        final vehicleIds = vehicleEngineHours.keys.toList();
        final requiredEngineHoursList = vehicleEngineHours.values.toList();
        for (var i = 0; i < amountPickedVehicles; i++) {
          final vehicleId = vehicleIds[i];
          final requiredEngineHours = requiredEngineHoursList[i];
          final vehicleBuildingObjectID = await _vehicleBuildingObjectApiClient
              .saveVehicleBuildingObjectToDatabase(
            buildingObjectId: buildingObjectId,
            vehicleId: vehicleId,
            requiredEngineHours: requiredEngineHours,
          );
          if (vehicleBuildingObjectID != null) {
            final vehicleBuildingObject = VehicleBuildingObject(
              id: vehicleBuildingObjectID,
              buildingObjectId: buildingObjectId,
              vehicleId: vehicleId,
              requiredEngineHours: requiredEngineHours,
            );
            final vehicleBuildingObjectDataProvider =
                VehicleBuildingObjectDataProvider(buildingObjectId);
            await vehicleBuildingObjectDataProvider
                .putVehicleBuildingObjectToHive(vehicleBuildingObject);
            await vehicleBuildingObjectDataProvider.dispose();
          }
        }
      }
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.buildingObject,
          entityObjectId: buildingObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      final buildingObject = BuildingObject(
        objectId: buildingObjectId,
        title: title,
        startDate: startDate,
        finishDate: finishDate,
        description: description,
        isCompleted: isCompleted,
        imagesIdUrl: savedImagesIdUrl,
      );
      await _buildingObjectDataProvider.putBuildingObjectToHive(buildingObject);
    }
  }

  Future<List<BuildingObject>> downloadBuildingObjects() async {
    final buildingObjectListFromServer =
        await _buildingObjectApiClient.getBuildingObjectList();
    await _buildingObjectDataProvider
        .deleteAllUnnecessaryBuildingObjectsFromHive(
            buildingObjectListFromServer);

    for (var buildingObject in buildingObjectListFromServer) {
      await _buildingObjectDataProvider.putBuildingObjectToHive(buildingObject);
      final vehicleBuildingObjectListFromServer =
          await _vehicleBuildingObjectApiClient
              .downloadVehicleBuildingObjectList(buildingObject.objectId);
      final vehicleBuildingObjectDataProvider =
          VehicleBuildingObjectDataProvider(buildingObject.objectId);
      await vehicleBuildingObjectDataProvider
          .deleteUnnecessaryVehicleBuildingObjectsFromHive(
              vehicleBuildingObjectListFromServer);
      for (var vehicleBuildingObject in vehicleBuildingObjectListFromServer) {
        await vehicleBuildingObjectDataProvider
            .putVehicleBuildingObjectToHive(vehicleBuildingObject);
      }
      await vehicleBuildingObjectDataProvider.dispose();
    }
    return await getBuildingObjectsListFromHive();
  }

  Future<List<BuildingObject>> getBuildingObjectsListFromHive() async {
    final buildingObjectsList =
        await _buildingObjectDataProvider.getBuildingObjectListFromHive();
    buildingObjectsList.sort((a, b) => a.startDate.compareTo(b
        .startDate)); //TODO Не совсем правильная сортировка, нужно еще проверять завершен ли объект, сделал для видео
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
    final vehicleBuildingObjectDataProvider =
        VehicleBuildingObjectDataProvider(buildingObjectId);
    final vehicleBuldingObjectList = await vehicleBuildingObjectDataProvider
        .getVehicleBuildingObjectListFromHive();
    int mostDangerVehicleStatus = -2; //-2 значит, что техника не выбрана
    for (var vehicleBuldingObject in vehicleBuldingObjectList) {
      final vehicle = await _vehicleDataProvider
          .getVehicleFromHive(vehicleBuldingObject.vehicleId);
      if (vehicle != null) {
        final vehicleStatus =
            vehicle.getVehicleStatusFromRoutineMaintenanceInfo(
                vehicleBuldingObject.requiredEngineHours);
        if (vehicleStatus > mostDangerVehicleStatus) {
          mostDangerVehicleStatus = vehicleStatus;
        }
      }
    }
    return mostDangerVehicleStatus;
  }

  Future<Stream<BoxEvent>> getBuildingObjectStream() async {
    final buildingObjectStream =
        await _buildingObjectDataProvider.getBuildingObjectStream();
    return buildingObjectStream;
  }

  Future<void> updateBuildingObject({
    required String objectId,
    String? title,
    DateTime? startDate,
    DateTime? finishDate,
    String? description,
    bool? isCompleted,
    List<XFile>? imagesList,
    required Map<String, int> vehicleEngineHours,
  }) async {
    final buildingObjectId =
        await _buildingObjectApiClient.updateBuildingObject(
      objectId: objectId,
      title: title,
      startDate: startDate,
      finishDate: finishDate,
      description: description,
      isCompleted: isCompleted,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (buildingObjectId != null) {
      if (vehicleEngineHours.isNotEmpty) {
        final amountPickedVehicles = vehicleEngineHours.length;
        final vehicleIds = vehicleEngineHours.keys.toList();
        final requiredEngineHoursList = vehicleEngineHours.values.toList();
        for (var i = 0; i < amountPickedVehicles; i++) {
          final vehicleId = vehicleIds[i];
          final requiredEngineHours = requiredEngineHoursList[i];
          final vehicleBuildingObjectID = await _vehicleBuildingObjectApiClient
              .saveVehicleBuildingObjectToDatabase(
            buildingObjectId: buildingObjectId,
            vehicleId: vehicleId,
            requiredEngineHours: requiredEngineHours,
          );
          if (vehicleBuildingObjectID != null) {
            final vehicleBuildingObject = VehicleBuildingObject(
              id: vehicleBuildingObjectID,
              buildingObjectId: buildingObjectId,
              vehicleId: vehicleId,
              requiredEngineHours: requiredEngineHours,
            );
            final vehicleBuildingObjectDataProvider =
                VehicleBuildingObjectDataProvider(buildingObjectId);
            await vehicleBuildingObjectDataProvider
                .putVehicleBuildingObjectToHive(vehicleBuildingObject);
            await vehicleBuildingObjectDataProvider.dispose();
          }
        }
      }
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.buildingObject,
          entityObjectId: buildingObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      await _buildingObjectDataProvider.updateBuildingObjectInHive(
        buildingObjectId: buildingObjectId,
        title: title,
        startDate: startDate,
        finishDate: finishDate,
        description: description,
        isCompleted: isCompleted,
        imagesIdUrl: savedImagesIdUrl,
      );
    }
  }

  Future<void> deleteBuildingObject(String buildingObjectId) async {
    await _buildingObjectApiClient.deleteBuildingObject(buildingObjectId);
    await _buildingObjectDataProvider
        .deleteBuildingObjectFromHive(buildingObjectId);
  }

  Future<void> dispose() async {
    await _buildingObjectDataProvider.dispose();
  }
}
