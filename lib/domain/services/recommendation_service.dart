import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:autospectechnics/domain/api_clients/photos_to_entity_adding_relation_api_client.dart';
import 'package:autospectechnics/domain/api_clients/recommendation_api_client.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:image_picker/image_picker.dart';

class RecommendationService {
  final _recommendationApiClient = RecommendationApiClient();
  final _imagesApiClient = ImagesApiClient();
  final _photosToEntityApiClient = PhotosToEntityAddingRelationApiClient();

  Future<void> createRecommendation({
    required String title,
    required String vehicleNode,
    required String description,
    bool isCompleted = false,
    List<XFile>? imagesList,
  }) async {
    await _recommendationApiClient.saveRecommendationToDatabase(
        title: title,
        vehicleNode: vehicleNode,
        description: description,
        isCompleted: isCompleted);
    if (imagesList != null && imagesList.isNotEmpty) {
      await _imagesApiClient.saveImagesToDatabase(imagesList);
      await _photosToEntityApiClient.addPhotosRelationToEntity(
        parseObjectName: ParseObjectNames.recommendation,
        entityObjectId: _recommendationApiClient.recommendationObjectId,
        imageObjectIdList: _imagesApiClient.savedImagesObjectIds,
      );
    }
  }

  Future<void> updateRecommendation({
    required String objectId,
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
    List<XFile>? imagesList,
  }) async {
    await _recommendationApiClient.updateRecommendationInDatabase(
        objectId: objectId,
        title: title,
        vehicleNode: vehicleNode,
        description: description,
        isCompleted: isCompleted);
    //TODO С изображениями сложнее, нужно либо оставить все старые, либо удалить каие-то старые и добавить новые, либо просто удалить, этот метод нерабочий 
    if (imagesList != null && imagesList.isNotEmpty) {
      await _imagesApiClient.saveImagesToDatabase(imagesList);
      await _photosToEntityApiClient.addPhotosRelationToEntity(
        parseObjectName: ParseObjectNames.recommendation,
        entityObjectId: _recommendationApiClient.recommendationObjectId,
        imageObjectIdList: _imagesApiClient.savedImagesObjectIds,
      );
    }
  }
}
