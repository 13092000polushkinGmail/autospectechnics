import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class CompletedRepairApiClient {
  Future<String?> saveCompletedRepairToDatabase({
    required String title,
    required int mileage,
    required String description,
    required DateTime date,
    required String vehicleNode,
    required String vehicleObjectId,
    String? breakageObjectId,
  }) async {
    var completedRepair = ParseObject(ParseObjectNames.completedRepair);

    completedRepair.set('title', title);
    completedRepair.set('mileage', mileage);
    completedRepair.set('description', description);
    completedRepair.set('date', date);
    completedRepair.set('vehicleNode', vehicleNode);
    completedRepair.set(
        'vehicle',
        (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
            .toPointer());

    if (breakageObjectId != null) {
      completedRepair.set(
          'breakage',
          (ParseObject(ParseObjectNames.breakage)..objectId = breakageObjectId)
              .toPointer());
    }

    final ParseResponse apiResponse = await completedRepair.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    return completedRepair.objectId;
  }

  Future<String?> updateCompletedRepair({
    required String objectId,
    String? title,
    int? mileage,
    String? description,
    DateTime? date,
    String? vehicleNode,
  }) async {
    var completedRepair = ParseObject(ParseObjectNames.completedRepair);
    completedRepair.objectId = objectId;

    if (title != null) {
      completedRepair.set('title', title);
    }

    if (mileage != null) {
      completedRepair.set('mileage', mileage);
    }

    if (description != null) {
      completedRepair.set('description', description);
    }

    if (date != null) {
      completedRepair.set('date', date);
    }

    if (vehicleNode != null) {
      completedRepair.set('vehicleNode', vehicleNode);
    }

    if (title != null ||
        mileage != null ||
        vehicleNode != null ||
        description != null ||
        date != null) {
      final ParseResponse apiResponse = await completedRepair.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
    return completedRepair.objectId;
  }

  Future<void> deleteCompletedRepairFromDatabase(
      String completedRepairId) async {
    final parseCompletedRepair = ParseObject(ParseObjectNames.completedRepair)
      ..objectId = completedRepairId;

    final ParseResponse apiResponse = await parseCompletedRepair.delete();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
  }

  Future<List<CompletedRepair>> getCompletedRepairList({
    required String vehicleObjectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.completedRepair))
          ..whereEqualTo(
            'vehicle',
            (ParseObject(ParseObjectNames.vehicle)..objectId = vehicleObjectId)
                .toPointer(),
          )
          ..orderByDescending('date');

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final List<CompletedRepair> completedRepairList = [];

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      for (var element in apiResponseResults) {
        final completedRepairObject = element as ParseObject;

        final objectId = completedRepairObject.objectId ?? '?????? objectId';
        List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

        final completedRepair = CompletedRepair.getCompletedRepair(
          completedRepairObject: completedRepairObject,
          imagesList: imagesList,
        );

        completedRepairList.add(completedRepair);
      }
    }
    return completedRepairList;
  }

  Future<CompletedRepair?> getCompletedRepair({
    required String objectId,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.completedRepair))
          ..whereEqualTo('objectId', objectId);

    final ParseResponse apiResponse = await parseQuery.query();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    final apiResponseResults = apiResponse.results;
    if (apiResponseResults != null) {
      final completedRepairObject = apiResponseResults.first as ParseObject;
      List<ParseObject> imagesList = await _getPhotosList(objectId: objectId);

      final completedRepair = CompletedRepair.getCompletedRepair(
        completedRepairObject: completedRepairObject,
        imagesList: imagesList,
      );

      return completedRepair;
    }
  }

  //TODO ???????? ?????????????????? ??????????, ?????????????? ?????? ?? ?????????????????? ????????, ???????????? ?????? ???????????????????????? ???? ???????????? ?????? ????????????????, ???????????????????? ???????????? ParseObjectNames
  Future<List<ParseObject>> _getPhotosList({
    required String objectId,
  }) async {
    QueryBuilder<ParseObject> queryPhotos =
        QueryBuilder<ParseObject>(ParseObject(ParseObjectNames.image))
          ..whereRelatedTo(
            'photos',
            ParseObjectNames.completedRepair,
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
