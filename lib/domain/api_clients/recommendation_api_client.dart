import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RecommendationApiClient {
  Future<String?> saveRecommendationToDatabase({
    required String title,
    required String vehicleNode,
    required String description,
    required bool isCompleted,
    required String vehicleObjectId,
  }) async {
    var recommendation = ParseObject(ParseObjectNames.recommendation);
    recommendation.set('title', title);
    recommendation.set('vehicleNode', vehicleNode);
    recommendation.set('description', description);
    recommendation.set('isCompleted', isCompleted);
    recommendation.set(
        'vehicle',
        (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
            .toPointer());

    final ParseResponse apiResponse = await recommendation.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return recommendation.objectId;
  }

  Future<String?> updateRecommendationInDatabase({
    required String objectId,
    String? title,
    String? vehicleNode,
    String? description,
    bool? isCompleted,
  }) async {
    var recommendation = ParseObject(ParseObjectNames.recommendation);
    recommendation.objectId = objectId;

    if (title != null) {
      recommendation.set('title', title);
    }

    if (vehicleNode != null) {
      recommendation.set('vehicleNode', vehicleNode);
    }

    if (description != null) {
      recommendation.set('description', description);
    }

    if (isCompleted != null) {
      recommendation.set('isCompleted', isCompleted);
    }

    if (title != null ||
        vehicleNode != null ||
        description != null ||
        isCompleted != null) {
      final ParseResponse apiResponse = await recommendation.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
    return recommendation.objectId;
  }

  Future<void> deleteRecommendationFromDatabase(String recommendationId) async {
    final parseRecommendation = ParseObject(ParseObjectNames.recommendation)
      ..objectId = recommendationId;

    final ParseResponse apiResponse = await parseRecommendation.delete();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<Recommendation>> getVehicleRecommendationList({
    required String vehicleObjectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.recommendation))
          ..whereEqualTo(
            'vehicle',
            (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
                .toPointer(),
          );

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final List<Recommendation> recommendationList = [];

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      for (var element in apiResponseResults) {
        final recommendationObject = element as ParseObject;

        final objectId = recommendationObject.objectId ?? 'Нет objectId';
        List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

        final recommendation = Recommendation.getRecommendation(
          recommendationObject: recommendationObject,
          imagesList: imagesList,
        );
        recommendationList.add(recommendation);
      }
    }
    return recommendationList;
  }

  Future<Recommendation?> getRecommendation({
    required String objectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.recommendation))
          ..whereEqualTo('objectId', objectId);

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      final recommendationObject = apiResponseResults.first as ParseObject;
      List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

      final recommendation = Recommendation.getRecommendation(
        recommendationObject: recommendationObject,
        imagesList: imagesList,
      );
      return recommendation;
    }
  }

  Future<List<ParseObject>> _getPhotosList({
    required String objectId,
  }) async {
    QueryBuilder<ParseObject> queryPhotos =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
          ..whereRelatedTo(
            'photos',
            ParseObjectNames.recommendation,
            objectId,
          );

    final ParseResponse responsePhotos = await queryPhotos.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(responsePhotos);

    List<ParseObject> imagesList = [];
    if (responsePhotos.results != null) {
      imagesList = responsePhotos.results as List<ParseObject>;
    }
    return imagesList;
  }
}
