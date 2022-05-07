import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class BreakageApiClient {
  Future<String?> saveBreakageToDatabase({
    required String title,
    required String vehicleNode,
    required int dangerLevel,
    required String description,
    required bool isFixed,
    required String vehicleObjectId,
  }) async {
    var breakage = ParseObject(ParseObjectNames.breakage);
    breakage.set('title', title);
    breakage.set('vehicleNode', vehicleNode);
    breakage.set('dangerLevel', dangerLevel);
    breakage.set('description', description);
    breakage.set('isFixed', isFixed);
    breakage.set(
        'vehicle',
        (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
            .toPointer());

    final ParseResponse apiResponse = await breakage.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return breakage.objectId;
  }

  Future<List<Breakage>> getVehicleBreakageList({
    required String vehicleObjectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.breakage))
          ..whereEqualTo(
            'vehicle',
            (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
                .toPointer(),
          )
          ..orderByDescending('dangerLevel');

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final List<Breakage> breakageList = [];
    
    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      for (var element in apiResponseResults) {
        final breakageObject = element as ParseObject;

        final objectId = breakageObject.objectId ?? 'Нет objectId';
        List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

        final breakage = Breakage.getBreakage(
          breakageObject: breakageObject,
          imagesList: imagesList,
        );

        breakageList.add(breakage);
      }
    }
    return breakageList;
  }

  Future<Breakage?> getBreakage({
    required String objectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.breakage))
          ..whereEqualTo('objectId', objectId);

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      final breakageObject = apiResponseResults.first as ParseObject;
      List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

      final breakage = Breakage.getBreakage(
        breakageObject: breakageObject,
        imagesList: imagesList,
      );
      return breakage;
    }
  }

  Future<List<ParseObject>> _getPhotosList({
    required String objectId,
  }) async {
    QueryBuilder<ParseObject> queryPhotos =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
          ..whereRelatedTo(
            'photos',
            ParseObjectNames.breakage,
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
