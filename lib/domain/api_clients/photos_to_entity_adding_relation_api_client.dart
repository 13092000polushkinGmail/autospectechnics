import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class PhotosToEntityAddingRelationApiClient {
  Future<void> addPhotosRelationToEntity({
    required String parseObjectName,
    required String entityObjectId,
    required List<String> imageObjectIdList,
  }) async {
    var entity = ParseObject(parseObjectName);
    entity.set('objectId', entityObjectId);
    entity.addRelation(
        'photos',
        imageObjectIdList
            .map((objectId) =>
                ParseObject(ParseObjectNames.image)..set('objectId', objectId))
            .toList());

    final ParseResponse apiResponse = await entity.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<void> addPhotoPointerToEntity({
    required String parseObjectName,
    required String entityObjectId,
    required String imageObjectId,
  }) async {
    var entity = ParseObject(parseObjectName);
    entity.set('objectId', entityObjectId);
    entity.set(
        'photo',
        (ParseObject(ParseObjectNames.image)..objectId = imageObjectId)
            .toPointer());

    final ParseResponse apiResponse = await entity.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }
}
