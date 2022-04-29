import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RecommendationApiClient {
  String _recommendationObjectId = '';
  String get recommendationObjectId => _recommendationObjectId;

  Future<void> saveRecommendationToDatabase({
    required String title,
    required String vehicleNode,
    required String description,
    required bool isCompleted,
  }) async {
    var recommendation = ParseObject(ParseObjectNames.recommendation);
    recommendation.set('title', title);
    recommendation.set('vehicleNode', vehicleNode);
    recommendation.set('description', description);
    recommendation.set('isCompleted', isCompleted);

    final ParseResponse apiResponse = await recommendation.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    _recommendationObjectId = recommendation.objectId!;
  }

  Future<void> updateRecommendationInDatabase({
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

    final ParseResponse apiResponse = await recommendation.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    _recommendationObjectId = recommendation.objectId!;
  }

  // Future<void> getRecommendation() async {
  //   QueryBuilder<ParseObject> queryRecommendation =
  //       QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.recommendation))
  //         ..whereEqualTo('objectId', 'nUDxAWJ8mw');

  //   final ParseResponse responseRecommendation = await queryRecommendation.query();

  //   if (responseRecommendation.success && responseRecommendation.results != null) {
  //     final recommendation = (responseRecommendation.results?.first) as ParseObject;
  //   }

  //   QueryBuilder<ParseObject> queryAuthors =
  //       QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
  //         ..whereRelatedTo('photos', 'Recommendation', 'nUDxAWJ8mw');

  //   final ParseResponse responseAuthors = await queryAuthors.query();

  //   if (responseAuthors.success && responseAuthors.results != null) {
  //     final bookAuthors = responseAuthors.results;
  //         // .map((e) => (e as ParseObject).get<String>('name'))
  //         // .toList();
  //   }
  // }
}
