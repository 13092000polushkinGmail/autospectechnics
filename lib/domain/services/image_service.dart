import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile>? _imageFileList;
  List<XFile>? get imageFileList => _imageFileList;

  Future<void> pickImage({
    bool isMultiImage = true,
  }) async {
    if (isMultiImage) {
      _imageFileList = await _imagePicker.pickMultiImage();
    } else {
      final imageFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) _imageFileList = [imageFile];
    }
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
