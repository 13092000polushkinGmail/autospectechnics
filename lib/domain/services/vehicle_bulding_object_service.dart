import 'package:autospectechnics/domain/api_clients/vehicle_building_object_api_client.dart';
import 'package:autospectechnics/domain/data_providers/vehicle_building_object_data_provider.dart';
import 'package:autospectechnics/domain/entities/vehicle_building_object.dart';
import 'package:hive/hive.dart';

class VehicleBuildingObjectService {
  final String _buildingObjectId;
  final _vehicleBuildingObjectApiClient = VehicleBuildingObjectApiClient();
  late final _vehicleBuildingObjectDataProvider =
      VehicleBuildingObjectDataProvider(_buildingObjectId);

  VehicleBuildingObjectService(this._buildingObjectId);
  Future<List<VehicleBuildingObject>> getVehicleBuildingObjectListFromHive(
      String buildingObjectId) async {
    return await _vehicleBuildingObjectDataProvider
        .getVehicleBuildingObjectListFromHive();
  }

  Future<Stream<BoxEvent>> getVehicleBuildingObjectStream() async {
    final vehicleBuildingObjectStream = await _vehicleBuildingObjectDataProvider
        .getVehicleBuildingObjectStream();
    return vehicleBuildingObjectStream;
  }

  Future<void> updateVehicleBuildingObject({
    required String objectId,
    int? requiredEngineHours,
  }) async {
    // final
    // final recommendationObjectId =
    //     await _recommendationApiClient.updateRecommendationInDatabase(
    //   objectId: objectId,
    //   title: title,
    //   vehicleNode: vehicleNode,
    //   description: description,
    //   isCompleted: isCompleted,
    // );
    // Map<String, String> savedImagesIdUrl = {};
    // if (recommendationObjectId != null) {
    //   if (imagesList != null && imagesList.isNotEmpty) {
    //     savedImagesIdUrl =
    //         await _imagesApiClient.saveImagesToDatabase(imagesList);
    //     await _photosToEntityApiClient.addPhotosRelationToEntity(
    //       parseObjectName: ParseObjectNames.recommendation,
    //       entityObjectId: recommendationObjectId,
    //       imageObjectIdList: savedImagesIdUrl.keys.toList(),
    //     );
    //   }
    //   await _recommendationDataProvider.updateRecommendationInHive(
    //     recommendationId: recommendationObjectId,
    //     title: title,
    //     vehicleNode: vehicleNode,
    //     description: description,
    //     isCompleted: isCompleted,
    //     imagesIdUrl: savedImagesIdUrl,
    //   );
    // }
  }

  Future<void> deleteVehicleBuildingObjectsOfBuildingObject(
      String buildingObjectId) async {
    await _vehicleBuildingObjectApiClient
        .deleteVehicleBuildingObjectsOfBuildingObject(
            buildingObjectId: buildingObjectId);
    await _vehicleBuildingObjectDataProvider
        .deleteVehicleBuildingObjectsOfBuildingObjectFromHive();
  }

  Future<void> dispose() async {
    await _vehicleBuildingObjectDataProvider.dispose();
  }
}
