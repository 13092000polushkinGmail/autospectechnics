import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class BuildingObjectApiClient {
  Future<String?> saveBuildingObjectToDatabase({
    required String title,
    required DateTime startDate,
    required DateTime finishDate,
    required String description,
    required bool isCompleted,
  }) async {
    var buildingObject = ParseObject(ParseObjectNames.buildingObject);
    buildingObject.set('title', title);
    buildingObject.set('startDate', startDate);
    buildingObject.set('finishDate', finishDate);
    buildingObject.set('description', description);
    buildingObject.set('isCompleted', isCompleted);

    final ParseResponse apiResponse = await buildingObject.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return buildingObject.objectId;
  }

  Future<String?> updateBuildingObject({
    required String objectId,
    String? title,
    DateTime? startDate,
    DateTime? finishDate,
    String? description,
    bool? isCompleted,
  }) async {
    var buildingObject = ParseObject(ParseObjectNames.buildingObject);
    buildingObject.objectId = objectId;

    if (title != null) {
      buildingObject.set('title', title);
    }

    if (startDate != null) {
      buildingObject.set('startDate', startDate);
    }

    if (finishDate != null) {
      buildingObject.set('finishDate', finishDate);
    }

    if (description != null) {
      buildingObject.set('description', description);
    }

    if (isCompleted != null) {
      buildingObject.set('isCompleted', isCompleted);
    }

    if (title != null ||
        startDate != null ||
        finishDate != null ||
        description != null ||
        isCompleted != null) {
      final ParseResponse apiResponse = await buildingObject.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
    return buildingObject.objectId;
  }

  Future<void> deleteBuildingObject(String buildingObjectId) async {
    final parseBuildingObject = ParseObject(ParseObjectNames.buildingObject)
      ..objectId = buildingObjectId;

    final ParseResponse apiResponse = await parseBuildingObject.delete();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<BuildingObject>> getBuildingObjectList() async {
    List<BuildingObject> buildingObjectList = [];

    QueryBuilder<ParseObject> queryBuildingObject =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.buildingObject))
          ..orderByAscending('startDate');

    final ParseResponse apiResponse = await queryBuildingObject.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    if (apiResponse.results != null) {
      for (var result in apiResponse.results!) {
        final buildingObjectParse = result as ParseObject;

        final objectId = buildingObjectParse.objectId ?? 'Нет objectId';
        List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

        final buildingObject = BuildingObject.getBuildingObject(
          buildingObject: buildingObjectParse,
          imagesList: imagesList,
        );
        buildingObjectList.add(buildingObject);
      }
      return buildingObjectList;
    } else {
      throw ApiClientException(type: ApiClientExceptionType.emptyResponse);
    }
  }

  Future<List<ParseObject>> _getPhotosList({
    required String objectId,
  }) async {
    QueryBuilder<ParseObject> queryPhotos =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
          ..whereRelatedTo(
            'photos',
            ParseObjectNames.buildingObject,
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
