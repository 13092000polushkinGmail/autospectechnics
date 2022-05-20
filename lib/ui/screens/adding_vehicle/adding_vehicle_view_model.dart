import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:flutter/material.dart';

class AddingVehicleViewModel extends ChangeNotifier {
  final _imageService = ImageService();
  final _vehicleService = VehicleService();

  final modelTextControler = TextEditingController();
  final mileageTextControler = TextEditingController();
  final licensePlateTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  bool _isLoadingProgress = false;
  int _currentTabIndex = 0;
  int _maxPickedTabIndex = 0;

  bool get isLoadingProgress => _isLoadingProgress;
  
  Image? get image {
    final imageList = _imageService.imageList;
    if (imageList.isEmpty) {
      return null;
    } else {
      return _imageService.imageList.first;
    }
  }

  StepperWidgetConfiguration get stepperConfiguration =>
      StepperWidgetConfiguration(
        stepAmount: 5,
        currentTabIndex: _currentTabIndex,
        maxPickedTabIndex: _maxPickedTabIndex,
        setCurrentTabIndex: setCurrentTabIndex,
      );

  int get currentTabIndex => _currentTabIndex;

  void incrementCurrentTabIndex() {
    _currentTabIndex += 1;
    if (_currentTabIndex > _maxPickedTabIndex) {
      _maxPickedTabIndex = _currentTabIndex;
    }
    notifyListeners();
  }

  void decrementCurrentTabIndex() {
    _currentTabIndex -= 1;
    notifyListeners();
  }

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }

  Future<void> pickImage({
    required BuildContext context,
  }) async {
    try {
      await _imageService.pickImage(isMultiImage: false);
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
    int mileage = 0;

    final model = modelTextControler.text.trim();
    final mileageString = mileageTextControler.text.trim();
    final licensePlate = licensePlateTextControler.text.trim();
    final description = descriptionTextControler.text.trim();

    if (model.isEmpty) {
      _errorList.add('Поле "Марка и модель" не может быть пустым.');
    }

    if (mileageString.isEmpty) {
      _errorList.add('Поле "Пробег" не может быть пустым.');
    } else {
      final mileageTryParse = int.tryParse(mileageString);
      if (mileageTryParse == null) {
        _errorList.add('Введите целое число в поле "Пробег".');
      } else {
        mileage = mileageTryParse;
      }
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

    final imageFile = _imageService.imageFileList?.first;

    try {
      await _vehicleService.createVehicle(
        model: model,
        mileage: mileage,
        licensePlate: licensePlate,
        description: description,
        image: imageFile,
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

    _isLoadingProgress = false;
    notifyListeners();
  }
}
