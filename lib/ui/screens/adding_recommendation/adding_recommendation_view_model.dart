import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';

class AddingRecommendationViewModel extends ChangeNotifier {
  late final _recommendationService = RecommendationService(_vehicleObjectId);
  final _imageService = ImageService();

  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  final String _vehicleObjectId;
  AddingRecommendationViewModel(
    this._vehicleObjectId,
  );

  List<Image> get imageList => _imageService.imageList;

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
      await _recommendationService.createRecommendation(
        title: title,
        vehicleNode: vehicleNode,
        description: description,
        imagesList: _imageService.imageFileList,
      );
      //TODO Как-то сообщать об успехе операции, возможно
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
