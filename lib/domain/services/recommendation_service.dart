import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/recommendation_api_client.dart';
import 'package:autospectechnics/domain/data_providers/recommendation_data_provider.dart';
import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class RecommendationService {
  final String _vehicleObjectId;

  final _recommendationApiClient = RecommendationApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  RecommendationService(this._vehicleObjectId);
  late final _recommendationDataProvider =
      RecommendationDataProvider(_vehicleObjectId);

  Future<void> createRecommendation({
    required String title,
    required String vehicleNode,
    required String description,
    bool isCompleted = false,
    List<XFile>? imagesList,
  }) async {
    final recommendationObjectId =
        await _recommendationApiClient.saveRecommendationToDatabase(
      title: title,
      vehicleNode: vehicleNode,
      description: description,
      isCompleted: isCompleted,
      vehicleObjectId: _vehicleObjectId,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (recommendationObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.recommendation,
          entityObjectId: recommendationObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      final recommendation = Recommendation(
        objectId: recommendationObjectId,
        title: title,
        vehicleNode: vehicleNode,
        description: description,
        isCompleted: isCompleted,
        imagesIdUrl: savedImagesIdUrl,
      );
      await _recommendationDataProvider.putRecommendationToHive(recommendation);
    }
  }

  Future<List<Recommendation>> downloadVehicleRecommendations() async {
    final vehicleRecommendationsFromServer = await _recommendationApiClient
        .getVehicleRecommendationList(vehicleObjectId: _vehicleObjectId);
    await _recommendationDataProvider.deleteUnnecessaryRecommendationsFromHive(
        vehicleRecommendationsFromServer);
    for (var recommendation in vehicleRecommendationsFromServer) {
      await _recommendationDataProvider.putRecommendationToHive(recommendation);
    }
    return await getVehicleRecommendationsFromHive();
  }

  Future<List<Recommendation>> getVehicleRecommendationsFromHive() async {
    final vehicleRecommendations =
        await _recommendationDataProvider.getRecommendationsListFromHive();
    vehicleRecommendations
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return vehicleRecommendations;
  }

  Future<Recommendation?> getRecommendationFromHive(
      String recommendationObjectId) async {
    final recommendation = await _recommendationDataProvider
        .getRecommendationFromHive(recommendationObjectId);
    return recommendation;
  }

  Future<Stream<BoxEvent>> getRecommendationStream() async {
    final recommendationStream =
        await _recommendationDataProvider.getRecommendationStream();
    return recommendationStream;
  }

  Future<void> updateRecommendation({
    required String objectId,
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
    List<XFile>? imagesList,
  }) async {
    final recommendationObjectId =
        await _recommendationApiClient.updateRecommendationInDatabase(
      objectId: objectId,
      title: title,
      vehicleNode: vehicleNode,
      description: description,
      isCompleted: isCompleted,
    );
    Map<String, String> savedImagesIdUrl = {};
    if (recommendationObjectId != null) {
      if (imagesList != null && imagesList.isNotEmpty) {
        savedImagesIdUrl =
            await _imagesApiClient.saveImagesToDatabase(imagesList);
        await _photosToEntityApiClient.addPhotosRelationToEntity(
          parseObjectName: ParseObjectNames.recommendation,
          entityObjectId: recommendationObjectId,
          imageObjectIdList: savedImagesIdUrl.keys.toList(),
        );
      }
      await _recommendationDataProvider.updateRecommendationInHive(
        recommendationId: recommendationObjectId,
        title: title,
        vehicleNode: vehicleNode,
        description: description,
        isCompleted: isCompleted,
        imagesIdUrl: savedImagesIdUrl,
      );
    }
  }

  Future<void> deleteRecommendation(String recommendationId) async {
    await _recommendationApiClient
        .deleteRecommendationFromDatabase(recommendationId);
    await _recommendationDataProvider
        .deleteRecommendationFromHive(recommendationId);
  }

  Future<void> dispose() async {
    await _recommendationDataProvider.dispose();
  }
}
