import 'dart:io';

import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddingRecommendationViewModel extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final _recommendationService = RecommendationService();

  List<XFile>? _imageFileList;
  bool _isLoadingProgress = false;

  bool get isLoadingProgress => _isLoadingProgress;

  List<Image> get imageList {
    List<Image> imageList = [];
    final imageFileList = _imageFileList;
    if (imageFileList != null) {
      if (kIsWeb) {
        for (var imageFile in imageFileList) {
          imageList.add(Image.network(
            imageFile.path,
            fit: BoxFit.cover,
          ));
        }
      } else {
        for (var imageFile in imageFileList) {
          imageList.add(Image.file(
            File(imageFile.path),
            fit: BoxFit.cover,
          ));
        }
      }
    }
    return imageList;
  }

  int _selectedVehiicleNodeIndex = -1;
  int get selectedVehiicleNodeIndex => _selectedVehiicleNodeIndex;

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  void setSelectedVehiicleNodeIndex(int index) {
    _selectedVehiicleNodeIndex = index;
    notifyListeners();
  }

  Future<void> pickImage({
    required BuildContext context,
  }) async {
    try {
      _imageFileList = await _imagePicker.pickMultiImage();
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showErrorWithMessage(
        context,
        'Произошла ошибка при выборе изображения, пожалуйста, повторите попытку',
      );
    }
  }

  Future<void> saveToDatabase(BuildContext context) async {
    _isLoadingProgress = true;
    notifyListeners();
    List<String> _errorList = [];

    final title = titleTextControler.text.trim();
    final description = descriptionTextControler.text.trim();

    if (_selectedVehiicleNodeIndex < 0) {
      _errorList.add('Выберите узел автомобиля.');
    }

    if (title.isEmpty) {
      _errorList.add('Поле "Название" не может быть пустым.');
    }

    if (description.isEmpty) {
      _errorList.add('Поле "Описание" не может быть пустым.');
    }

    if (_errorList.isNotEmpty) {
      _isLoadingProgress = false;
      notifyListeners();
      String _errorMessage = '';
      for (var i = 0; i < _errorList.length; i++) {
        _errorMessage += '${i + 1}) ${_errorList[i]}\n';
      }
      ErrorDialogWidget.showErrorWithMessage(context, _errorMessage);
      return;
    }

    final vehicleNode =
        VehicleNodeNames.getNameByIndex(_selectedVehiicleNodeIndex);

    final imagesList = _imageFileList;

    try {
      await _recommendationService.createRecommendation(
          title: title,
          vehicleNode: vehicleNode,
          description: description,
          imagesList: imagesList);
      //TODO Как-то сообщать об успехе операции, возможно
      Navigator.of(context).pop();
    } on SocketException {
      ErrorDialogWidget.showConnectionError(context);
    } on ParseException catch (exception) {
      ErrorDialogWidget.showErrorWithMessage(context, exception.message);
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }

    _isLoadingProgress = false;
    notifyListeners();
  }
}

//Отображение картинок, загруженных из базы данных
// ParseFileBase? varFile =
//                             snapshot.data![index].get<ParseFileBase>('file');

//                         //Only iOS/Android/Desktop
//                         /*
//                         ParseFile? varFile =
//                             snapshot.data![index].get<ParseFile>('file');
//                         */
//                         return Image.network(
//                           varFile!.url!,
//                           width: 200,
//                           height: 200,
//                           fit: BoxFit.fitHeight,
//                         );
