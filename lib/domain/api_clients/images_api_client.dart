import 'dart:io';

import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ImagesApiClient {
  final List<String> _savedImagesObjectIds = [];
  List<String> get savedImagesObjectIds => _savedImagesObjectIds;

  Future<ParseObject> _saveImageToParseCloud(XFile imageFile) async {
    ParseFileBase _parseFile;
    if (kIsWeb) {
      _parseFile =
          ParseWebFile(await imageFile.readAsBytes(), name: 'image.jpg');
    } else {
      _parseFile = ParseFile(File(imageFile.path));
    }

    final ParseResponse apiResponse = await _parseFile.save();

    if (apiResponse.success && apiResponse.results != null) {
      return ParseObject(ParseObjectNames.image)..set('file', _parseFile);
    } else if (apiResponse.error?.exception is SocketException) {
      throw const SocketException('Проверьте подключение к интернету');
    } else {
      throw ParseException(
          message: apiResponse.error?.message ??
              'Неизвестная ошибка. Пожалуйста, повторите попытку.');
    }
  }

  Future<void> saveImagesToDatabase(List<XFile> imagesList) async {
    List<ParseObject> _parseObjectsList = [];
    for (var image in imagesList) {
      _parseObjectsList.add(await _saveImageToParseCloud(image));
    }

    for (var parseImage in _parseObjectsList) {
      final ParseResponse apiResponse = await parseImage.save();

      if (apiResponse.success && apiResponse.results != null) {
        _savedImagesObjectIds.add(parseImage.objectId!);
      } else if (apiResponse.error?.exception is SocketException) {
        throw const SocketException('Проверьте подключение к интернету');
      } else {
        throw ParseException(
            message: apiResponse.error?.message ??
                'Неизвестная ошибка. Пожалуйста, повторите попытку.');
      }
    }
  }

  //TODO Еще не тестировал
  Future<void> deleteImagesFromDatabase(List<String> imagesObjectIds) async {
    for (var imageId in imagesObjectIds) {
      final parseImage = ParseObject(ParseObjectNames.image)
        ..objectId = imageId;

      final ParseResponse apiResponse = await parseImage.delete();

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

  // Future<List<ParseObject>> getImagesList() async {
  //   QueryBuilder<ParseObject> queryPublisher =
  //       QueryBuilder<ParseObject>(ParseObject('Gallery'))
  //         ..orderByAscending('createdAt');
  //   final ParseResponse apiResponse = await queryPublisher.query();

  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }
}
