import 'dart:io';

import 'package:autospectechnics/domain/api_clients/images_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _imagePicker = ImagePicker();
  final _imagesApiClient = ImagesApiClient();
  List<XFile>? _imageFileList;
  List<XFile>? get imageFileList => _imageFileList;

  Future<void> pickImage({
    bool isMultiImage = true,
  }) async {
    if (isMultiImage) {
      final pickedImageFilesList = await _imagePicker.pickMultiImage();
      if (_imageFileList != null && pickedImageFilesList != null) {
        _imageFileList?.addAll(pickedImageFilesList);
      } else {
        _imageFileList = pickedImageFilesList;
      }
    } else {
      final imageFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) _imageFileList = [imageFile];
    }
  }

  void deleteImageFromFileList(int imageIndex) {
    _imageFileList?.removeAt(imageIndex);
  }

  Future<void> deleteImagesFromServer(List<String> imageObjectId) async {
    await _imagesApiClient.deleteImagesFromDatabase(imageObjectId);
  }

  List<Image> get imageList {
    const imageSize = 96.0;
    List<Image> imageList = [];
    final imageFileList = _imageFileList;
    if (imageFileList != null) {
      if (kIsWeb) {
        for (var imageFile in imageFileList) {
          imageList.add(
            Image.network(
              imageFile.path,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
            ),
          );
        }
      } else {
        for (var imageFile in imageFileList) {
          imageList.add(
            Image.file(
              File(imageFile.path),
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
            ),
          );
        }
      }
    }
    return imageList;
  }
}
