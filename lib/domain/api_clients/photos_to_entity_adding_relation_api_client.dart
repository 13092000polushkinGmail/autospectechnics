import 'dart:io';

import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
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

    if (apiResponse.success && apiResponse.results != null) {
      return;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
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

    if (apiResponse.success && apiResponse.results != null) {
      return;
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
  }
}
