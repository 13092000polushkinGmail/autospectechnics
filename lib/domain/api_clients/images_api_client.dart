import 'dart:io';

import 'package:autospectechnics/domain/api_clients/api_response_success_checker.dart';
import 'package:autospectechnics/domain/parse_database_string_names/parse_objects_names.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ImagesApiClient {
  Future<ParseObject> _saveImageToParseCloud(XFile imageFile) async {
    ParseFileBase parseFile;
    if (kIsWeb) {
      parseFile =
          ParseWebFile(await imageFile.readAsBytes(), name: 'image.jpg');
    } else {
      parseFile = ParseFile(File(imageFile.path));
    }

    final ParseResponse apiResponse = await parseFile.save();
    ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);

    return ParseObject(ParseObjectNames.image)..set('file', parseFile);
  }

  Future<Map<String, String>> saveImagesToDatabase(
      List<XFile> imagesList) async {
    List<ParseObject> parseObjectsList = [];
    for (var image in imagesList) {
      parseObjectsList.add(await _saveImageToParseCloud(image));
    }

    final savedImagesIdUrl = <String, String>{};

    for (var parseImage in parseObjectsList) {
      final ParseResponse apiResponse = await parseImage.save();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
      final apiResponseResults = apiResponse.results;
      if (apiResponseResults != null) {
        final savedImage = apiResponseResults.first as ParseObject;
        final imageURL = savedImage.get<ParseFile>('file')?.get<String>('url');
        if (imageURL != null) {
          savedImagesIdUrl[parseImage.objectId!] = imageURL;
        }
      }
    }
    return savedImagesIdUrl;
  }

  Future<void> deleteImagesFromDatabase(List<String> imagesObjectIds) async {
    for (var imageId in imagesObjectIds) {
      final parseImage = ParseObject(ParseObjectNames.image)
        ..objectId = imageId;

      final ParseResponse apiResponse = await parseImage.delete();
      ApiResponseSuccessChecker.checkApiResponseSuccess(apiResponse);
    }
  }
}
