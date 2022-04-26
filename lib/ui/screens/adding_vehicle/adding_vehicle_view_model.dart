import 'dart:io';

import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_stepper_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddingVehicleViewModel extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final _vehicleService = VehicleService();

  XFile? _imageFile;
  bool _isLoadingProgress = false;

  bool get isLoadingProgress => _isLoadingProgress;
  
  Image? get image {
    final imageFile = _imageFile;
    if (imageFile != null) {
      return kIsWeb
          ? Image.network(
              imageFile.path,
              //TODO Обратить внимание на этот BoxFit, возможно использовать его на странице автопарка 
              fit: BoxFit.cover,
            )
          : Image.file(
              File(imageFile.path),
              fit: BoxFit.cover,
            );
    }
  }

  var _currentTabIndex = 0;
  var _maxPickedTabIndex = 0;

  final modelTextControler = TextEditingController();
  final mileageTextControler = TextEditingController();
  final licensePlateTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  CircleStepConfiguration getCircleStepConfiguration(int index) {
    CircleStepState stepState;
    void Function()? onTap;

    if (index == _currentTabIndex) {
      stepState = CircleStepState.editing;
    } else if (index < _currentTabIndex) {
      stepState = CircleStepState.completed;
    } else if (index < _maxPickedTabIndex) {
      //&& index > _currentTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется, в нижних аналогично
      stepState = CircleStepState.completed;
    } else if (index == _maxPickedTabIndex) {
      stepState = CircleStepState.indexed;
    } else {
      stepState = CircleStepState
          .disabled; //index > _maxPickedTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется
    }

    if (stepState == CircleStepState.disabled) {
      onTap = null;
    } else {
      onTap = () => setCurrentTabIndex(index);
    }

    return CircleStepConfiguration(
        index: index, stepState: stepState, onTap: onTap);
  }

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
      _imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
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

    final image = _imageFile;

    try {
      await _vehicleService.createVehicle(
          model: model,
          mileage: mileage,
          licensePlate: licensePlate,
          description: description,
          image: image);
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
