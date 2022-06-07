import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';

class AddingRecommendationViewModel extends ChangeNotifier {
  late final _recommendationService = RecommendationService(_vehicleObjectId);
  final _imageService = ImageService();

  Recommendation? _recommendation;
  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  Map<String, String> imagesFromServerIdURLs = {};
  List<String> imagesIDsToDelete = [];

  final String _vehicleObjectId;
  final String _recommendationObjectId;
  AddingRecommendationViewModel(
    this._vehicleObjectId,
    this._recommendationObjectId,
    BuildContext context,
  ) {
    if (_recommendationObjectId != '') {
      _getRecommendation(context);
    }
  }

  List<Image> get pickedImageList => _imageService.imageList;
  String get screenTitle => _recommendationObjectId == '' ? 'Добавить рекомендацию' : 'Редактирование';

  Future<void> pickImage({
    required BuildContext context,
  }) async {
    try {
      await _imageService.pickImage();
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showErrorWithMessage(
        context,
        'Произошла ошибка при выборе изображения, пожалуйста, повторите попытку',
      );
    }
  }

  void deleteImageFile(
    BuildContext context,
    int imageIndex,
  ) {
    try {
      _imageService.deleteImageFromFileList(imageIndex);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
  }

  void deleteImageFromServer(
    BuildContext context,
    String imageObjectId,
  ) {
    try {
      imagesFromServerIdURLs.remove(imageObjectId);
      imagesIDsToDelete.add(imageObjectId);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
  }

  Future<void> _getRecommendation(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _recommendation = await _recommendationService
          .getRecommendationFromHive(_recommendationObjectId);
      if (_recommendation == null) {
        ErrorDialogWidget.showDataSyncingError(context);
      }
      titleTextControler.text = _recommendation?.title ?? '';
      descriptionTextControler.text = _recommendation?.description ?? '';
      selectedVehiicleNodeIndex =
          VehicleNodeNames.getIndexByName(_recommendation?.vehicleNode ?? '');
      imagesFromServerIdURLs = Map<String, String>.from(
          _recommendation?.imagesIdUrl ?? <String, String>{});
    } on ApiClientException catch (exception) {
      switch (exception.type) {
        case ApiClientExceptionType.network:
          ErrorDialogWidget.showConnectionError(context);
          break;
        case ApiClientExceptionType.emptyResponse:
          ErrorDialogWidget.showEmptyResponseError(context);
          break;
        case ApiClientExceptionType.other:
          ErrorDialogWidget.showErrorWithMessage(context, exception.message);
          break;
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
    isLoadingProgress = false;
    notifyListeners();
  }

  Future<void> saveToDatabase(BuildContext context) async {
    List<String> _errorList = [];

    final title = titleTextControler.text.trim();
    final description = descriptionTextControler.text.trim();

    if (selectedVehiicleNodeIndex < 0) {
      _errorList.add('Выберите узел автомобиля.');
    }

    if (title.isEmpty) {
      _errorList.add('Поле "Название" не может быть пустым.');
    }

    if (description.isEmpty) {
      _errorList.add('Поле "Описание" не может быть пустым.');
    }

    if (_errorList.isNotEmpty) {
      String _errorMessage = '';
      for (var i = 0; i < _errorList.length; i++) {
        _errorMessage += '${i + 1}) ${_errorList[i]}\n';
      }
      ErrorDialogWidget.showErrorWithMessage(context, _errorMessage);
      return;
    }

    isLoadingProgress = true;
    notifyListeners();

    final vehicleNode =
        VehicleNodeNames.getNameByIndex(selectedVehiicleNodeIndex);

    try {
      if (_recommendationObjectId == '') {
        await _recommendationService.createRecommendation(
          title: title,
          vehicleNode: vehicleNode,
          description: description,
          imagesList: _imageService.imageFileList,
        );
      } else {
        await _imageService.deleteImagesFromServer(imagesIDsToDelete);
        for (var id in imagesIDsToDelete) {
          _recommendation?.imagesIdUrl.remove(id);
        }
        await _recommendationService.updateRecommendation(
          objectId: _recommendationObjectId,
          title: title == _recommendation?.title ? null : title,
          vehicleNode:
              vehicleNode == _recommendation?.vehicleNode ? null : vehicleNode,
          description:
              description == _recommendation?.description ? null : description,
          imagesList: _imageService.imageFileList,
        );
      }
      Navigator.of(context).pop();
    } on ApiClientException catch (exception) {
      switch (exception.type) {
        case ApiClientExceptionType.network:
          ErrorDialogWidget.showConnectionError(context);
          break;
        case ApiClientExceptionType.emptyResponse:
          ErrorDialogWidget.showEmptyResponseError(context);
          break;
        case ApiClientExceptionType.other:
          ErrorDialogWidget.showErrorWithMessage(context, exception.message);
          break;
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }

    isLoadingProgress = false;
    notifyListeners();
  }

  void setSelectedVehiicleNodeIndex(int index) {
    selectedVehiicleNodeIndex = index;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _recommendationService.dispose();
    super.dispose();
  }
}
