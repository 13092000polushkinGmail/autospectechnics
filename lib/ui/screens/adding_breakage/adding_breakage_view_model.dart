import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddingBreakageViewModel extends ChangeNotifier {
  late final _breakageService = BreakageService(_vehicleObjectId);
  final _imageService = ImageService();

  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;
  int selectedDangerLevelIndex = -1;

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  final String _vehicleObjectId;
  AddingBreakageViewModel(
    this._vehicleObjectId,
  );

  List<Image> get imageList => _imageService.imageList;
  BreakageDangerLevelConfiguration getCircleStepConfiguration(int index) {
    return BreakageDangerLevelConfiguration(
      index: index,
      selectedDangerLevelIndex: selectedDangerLevelIndex,
      onTap: () => setSelectedDangerLevelIndex(index),
    );
  }

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

    if (selectedDangerLevelIndex < 0) {
      _errorList.add('Выберите уровень критичности');
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
      await _breakageService.createBreakage(
        title: title,
        vehicleNode: vehicleNode,
        dangerLevel: selectedDangerLevelIndex - 1,
        description: description,
        imagesList: _imageService.imageFileList,
      );
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

  void setSelectedDangerLevelIndex(int index) {
    selectedDangerLevelIndex = index;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _breakageService.dispose();
    super.dispose();
  }
}

class BreakageDangerLevelConfiguration {
  final void Function() onTap;

  String dangerLevelIconName = '';
  late Color stepConnectorColor;

  BreakageDangerLevelConfiguration({
    required int index,
    required int selectedDangerLevelIndex,
    required this.onTap,
  }) {
    final isPicked = index == selectedDangerLevelIndex;
    if (selectedDangerLevelIndex == 0) {
      stepConnectorColor = AppColors.green;
    } else if (selectedDangerLevelIndex == 1) {
      stepConnectorColor = AppColors.yellow;
    } else if (selectedDangerLevelIndex == 2) {
      stepConnectorColor = AppColors.red;
    } else {
      stepConnectorColor = AppColors.greyBorder;
    }
    if (isPicked) {
      if (index == 0) {
        dangerLevelIconName = AppSvgs.minorBreakage;
      } else if (index == 1) {
        dangerLevelIconName = AppSvgs.significantBreakage;
      } else {
        dangerLevelIconName = AppSvgs.criticalBreakage;
      }
    }
  }
}
