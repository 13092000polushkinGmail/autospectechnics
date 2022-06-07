import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddingBreakageViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();
  late final _breakageService = BreakageService(_vehicleObjectId);
  final _imageService = ImageService();

  Breakage? _breakage;
  bool isLoadingProgress = false;
  int selectedVehiicleNodeIndex = -1;
  int selectedDangerLevelIndex = -1;

  final titleTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  Map<String, String> imagesFromServerIdURLs = {};
  List<String> imagesIDsToDelete = [];

  final String _vehicleObjectId;
  final String _breakageObjectId;
  AddingBreakageViewModel(
    this._vehicleObjectId,
    this._breakageObjectId,
    BuildContext context,
  ) {
    if (_breakageObjectId != '') {
      _getBreakage(context);
    }
  }

  List<Image> get pickedImageList => _imageService.imageList;
  String get screenTitle =>
      _breakageObjectId == '' ? 'Добавить поломку' : 'Редактирование';

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

  Future<void> _getBreakage(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _breakage = await _breakageService.getBreakageFromHive(_breakageObjectId);
      if (_breakage == null) {
        ErrorDialogWidget.showDataSyncingError(context);
      }
      titleTextControler.text = _breakage?.title ?? '';
      descriptionTextControler.text = _breakage?.description ?? '';
      selectedVehiicleNodeIndex =
          VehicleNodeNames.getIndexByName(_breakage?.vehicleNode ?? '');
      final breakageDangerLevel = _breakage?.dangerLevel;
      selectedDangerLevelIndex =
          breakageDangerLevel == null ? -1 : breakageDangerLevel + 1;
      imagesFromServerIdURLs = Map<String, String>.from(
          _breakage?.imagesIdUrl ?? <String, String>{});
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
      if (_breakageObjectId == '') {
        await _breakageService.createBreakage(
          title: title,
          vehicleNode: vehicleNode,
          dangerLevel: selectedDangerLevelIndex - 1,
          description: description,
          imagesList: _imageService.imageFileList,
        );
      } else {
        await _imageService.deleteImagesFromServer(imagesIDsToDelete);
        for (var id in imagesIDsToDelete) {
          _breakage?.imagesIdUrl.remove(id);
        }
        await _breakageService.updateBreakage(
          objectId: _breakageObjectId,
          title: title == _breakage?.title ? null : title,
          vehicleNode:
              vehicleNode == _breakage?.vehicleNode ? null : vehicleNode,
          dangerLevel: selectedDangerLevelIndex - 1 == _breakage?.dangerLevel
              ? null
              : selectedDangerLevelIndex - 1,
          description:
              description == _breakage?.description ? null : description,
          imagesList: _imageService.imageFileList,
        );
      }
      final vehicleBreakageDangerLevel =
          await _breakageService.getVehicleDangerLevel();
      final vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      if (vehicle?.breakageDangerLevel != vehicleBreakageDangerLevel) {
        await _vehicleService.updateVehicle(
            vehicleId: _vehicleObjectId,
            breakageDangerLevel: vehicleBreakageDangerLevel);
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

  void setSelectedDangerLevelIndex(int index) {
    selectedDangerLevelIndex = index;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _breakageService.dispose();
    await _vehicleService.dispose();
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
