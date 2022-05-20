import 'package:flutter/material.dart';

import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/building_object_service.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';

class AddingObjectViewModel extends ChangeNotifier {
  final _imageService = ImageService();
  final _buildingObjectService = BuildingObjectService();
  final _vehicleService = VehicleService();

  var _currentTabIndex = 0;
  var _maxPickedTabIndex = 0;
  bool _isLoadingProgress = false;
  DateTime? _startDate;
  DateTime? _finishDate;

  final List<_VehicleWithIsActiveFlag> _vehiclesList = [];
  final Map<String, TextEditingController> _vehicleEngineHoursTextControllers =
      {};

  final titleTextController = TextEditingController();
  final descriptionTextControler = TextEditingController();

  AddingObjectViewModel(BuildContext context) {
    getVehicles(context);
  }

  int get currentTabIndex => _currentTabIndex;
  bool get isLoadingProgress => _isLoadingProgress;
  String get startDate => DateFormatter.getFormattedDate(_startDate);
  String get finishDate => DateFormatter.getFormattedDate(_finishDate);
  List<Image> get imageList => _imageService.imageList;
  int get vehiclesListLength => _vehiclesList.length;

  StepperWidgetConfiguration get stepperConfiguration =>
      StepperWidgetConfiguration(
        stepAmount: 3,
        currentTabIndex: _currentTabIndex,
        maxPickedTabIndex: _maxPickedTabIndex,
        setCurrentTabIndex: setCurrentTabIndex,
      );

  NecessaryVehicleWidgetConfiguration getVehicleWidgetConfiguration(int index) {
    final vehicleWithIsActiveFlag = _vehiclesList[index];
    return NecessaryVehicleWidgetConfiguration(
      isActive: vehicleWithIsActiveFlag.isActive,
      imageURL: vehicleWithIsActiveFlag.vehicle.imageURL,
      title: vehicleWithIsActiveFlag.vehicle.model,
    );
  }

  List<RequiredEngineHoursWidgetConfiguration>
      get requiredEngineHoursWidgetConfigurationList {
    final configurationList = <RequiredEngineHoursWidgetConfiguration>[];
    for (var i = 0; i < _vehiclesList.length; i++) {
      if (_vehiclesList[i].isActive) {
        configurationList.add(
          RequiredEngineHoursWidgetConfiguration(
            title: _vehiclesList[i].vehicle.model,
            controller: _vehicleEngineHoursTextControllers[
                    _vehiclesList[i].vehicle.objectId] ??
                TextEditingController(),
          ),
        );
      }
    }
    return configurationList;
  }

  Future<void> getVehicles(BuildContext context) async {
    try {
      final vehiclesList = await _vehicleService.getAllVehiclesFromHive();
      for (Vehicle vehicle in vehiclesList) {
        _vehiclesList.add(
          _VehicleWithIsActiveFlag(vehicle: vehicle, isActive: false),
        );
        _vehicleEngineHoursTextControllers[vehicle.objectId] =
            TextEditingController();
      }
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
  }

  void onVehicleCardTap(int index) {
    _vehiclesList[index].isActive = !_vehiclesList[index].isActive;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = isStartDate ? _startDate : _finishDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      locale: const Locale("ru", "RU"),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDatePickerMode: DatePickerMode.day,
      helpText: isStartDate
          ? 'Выберите дату начала работ на объекте'
          : 'Выберите дату завершения работ на объекте',
    );
    if (picked != null) {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _finishDate = picked;
      }
      notifyListeners();
    }
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
    _isLoadingProgress = true;
    notifyListeners();
    List<String> _errorList = [];

    final title = titleTextController.text.trim();
    final description = descriptionTextControler.text.trim();

    if (title.isEmpty) {
      _errorList.add('Поле "Название" не может быть пустым.');
    }

    if (_startDate == null) {
      _errorList.add('Поле "Дата начала работ" не может быть пустым.');
    }

    if (_finishDate == null) {
      _errorList.add('Поле "Дата окончания работ" не может быть пустым.');
    }

    if (_finishDate != null &&
        _startDate != null &&
        _finishDate!.isBefore(_startDate!)) {
      _errorList
          .add('Дата завершения работ не может быть раньше даты начала работ.');
    }
    Map<String, int> vehicleEngineHours = {};

    for (var i = 0; i < _vehiclesList.length; i++) {
      if (_vehiclesList[i].isActive) {
        final textController = _vehicleEngineHoursTextControllers[
            _vehiclesList[i].vehicle.objectId];
        if (textController == null || textController.text.isEmpty) {
          _errorList.add(
              'Заполните данные о необходимых моточасах для всей выбранной техники');
          break;
        }
        final requiredEngineHours = int.tryParse(textController.text);
        if (requiredEngineHours == null) {
          _errorList.add(
              'Необходимые моточасы нужно вводить в целочисленном формате');
          break;
        }
        vehicleEngineHours[_vehiclesList[i].vehicle.objectId] =
            requiredEngineHours;
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

    try {
      await _buildingObjectService.createBuildingObject(
        title: title,
        startDate: _startDate!,
        finishDate: _finishDate!,
        description: description,
        imagesList: _imageService.imageFileList,
        vehicleEngineHours: vehicleEngineHours,
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

    _isLoadingProgress = false;
    notifyListeners();
  }

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
}

class NecessaryVehicleWidgetConfiguration {
  final String title;
  String? imageURL;
  bool isActive;
  late Color textColor;
  late Color borderColor;
  late double borderWidth;

  NecessaryVehicleWidgetConfiguration({
    required this.isActive,
    required this.imageURL,
    required this.title,
  }) {
    if (isActive) {
      textColor = AppColors.blue;
      borderColor = AppColors.blue;
      borderWidth = 1.5;
    } else {
      textColor = AppColors.black;
      borderColor = AppColors.greyBorder;
      borderWidth = 1;
    }
  }
}

class RequiredEngineHoursWidgetConfiguration {
  final String title;
  final TextEditingController controller;

  RequiredEngineHoursWidgetConfiguration({
    required this.title,
    required this.controller,
  });
}

class _VehicleWithIsActiveFlag {
  final Vehicle vehicle;
  bool isActive;
  _VehicleWithIsActiveFlag({
    required this.vehicle,
    required this.isActive,
  });
}
