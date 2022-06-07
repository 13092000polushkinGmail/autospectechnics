import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/ui/global_widgets/photo_option_dialog_widget.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/image_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';

class AddingVehicleViewModel extends ChangeNotifier {
  final _imageService = ImageService();
  final _vehicleService = VehicleService();
  late final _routineMaintenanceService = RoutineMaintenanceService(_vehicleId);

  final modelTextControler = TextEditingController();
  final mileageTextController = TextEditingController();
  final licensePlateTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  Vehicle? _vehicle;
  bool _isLoadingProgress = false;
  int _currentTabIndex = 0;
  int _maxPickedTabIndex = 0;
  int selectedVehicleTypeIndex = -1;
  final List<RoutineMaintenanceInfo> _routineMaintenances = [];
  final List<String> _routineMaintenancesIdToDelete = [];

  Map<String, String> imageFromServerIdURL = {};
  List<String> imageIDToDelete = [];

  final String _vehicleId;

  AddingVehicleViewModel(
    this._vehicleId,
    this._currentTabIndex,
    BuildContext context,
  ) {
    if (_vehicleId != '') {
      getVehicleInfo(context);
    }
  }

  bool get isLoadingProgress => _isLoadingProgress;
  int get routineMaintenanceAmount => _routineMaintenances.length;

  Image? get pickedImage {
    final imageList = _imageService.imageList;
    if (imageList.isEmpty) {
      return null;
    } else {
      return _imageService.imageList.first;
    }
  }

  Future<void> onPickedImageTap(BuildContext context) async {
    final isDelete =
        await PhotoOptionDialogWidget.isDeleteOption(context: context);
    if (isDelete == null) return;
    try {
      _imageService.deleteImageFromFileList(0);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
    if (!isDelete) {
      await pickImage(context: context);
    }
  }

  Future<void> onServerImageTap(BuildContext context) async {
    final isDelete =
        await PhotoOptionDialogWidget.isDeleteOption(context: context);
    if (isDelete == null) return;
    try {
      final imageId = imageFromServerIdURL.keys.first;
      imageFromServerIdURL.clear();
      imageIDToDelete.add(imageId);
      notifyListeners();
    } catch (e) {
      ErrorDialogWidget.showUnknownError(context);
    }
    if (!isDelete) {
      await pickImage(context: context);
    }
  }

  StepperWidgetConfiguration get stepperConfiguration =>
      StepperWidgetConfiguration(
        stepAmount: 3,
        currentTabIndex: _currentTabIndex,
        maxPickedTabIndex: _maxPickedTabIndex,
        setCurrentTabIndex: setCurrentTabIndex,
      );

  VehicleTypeWidgetConfiguration getVehicleTypeWidgetConfiguration(int index) {
    return VehicleTypeWidgetConfiguration(
        vehicleCard: VehicleTypeCard.vehicleTypeCardsConfiguration[index],
        isPicked: selectedVehicleTypeIndex == index);
  }

  RoutineMaintenanceWidgetConfiguration?
      getRoutineMaintenanceWidgetConfiguration(int index, bool isActive) {
    if (index < _routineMaintenances.length) {
      return RoutineMaintenanceWidgetConfiguration(
          _routineMaintenances[index], isActive);
    }
  }

  int get currentTabIndex => _currentTabIndex;

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

  void deleteRoutineMaintenance({
    required BuildContext context,
    required int index,
  }) {
    try {
      final objectId = _routineMaintenances[index].objectId;
      if (objectId != null) {
        _routineMaintenancesIdToDelete.add(objectId);
      }
      _routineMaintenances.removeAt(index);
      notifyListeners();
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
  }

  Future<void> getVehicleInfo(BuildContext context) async {
    _isLoadingProgress = true;
    notifyListeners();

    try {
      _vehicle =
          await _vehicleService.getVehicleFromHive(vehicleObjectId: _vehicleId);

      modelTextControler.text = _vehicle?.model ?? '';
      mileageTextController.text = _vehicle?.mileage.toString() ?? '';
      licensePlateTextControler.text = _vehicle?.licensePlate ?? '';
      descriptionTextControler.text = _vehicle?.description ?? '';
      selectedVehicleTypeIndex = _vehicle?.vehicleType ?? -1;
      imageFromServerIdURL =
          Map<String, String>.from(_vehicle?.imageIdUrl ?? <String, String>{});

      _routineMaintenances.addAll((await _routineMaintenanceService
              .getVehicleRoutineMaintenancesFromHive())
          .map((routineMaintenance) {
        final routineMaintenanceInfo = RoutineMaintenanceInfo();
        routineMaintenanceInfo.vehicleNodeIndex =
            VehicleNodeNames.getIndexByName(routineMaintenance.vehicleNode);
        routineMaintenanceInfo.titleTextController.text =
            routineMaintenance.title;
        routineMaintenanceInfo.periodicityTextController.text =
            routineMaintenance.periodicity.toString();
        routineMaintenanceInfo.isSaved = true;
        routineMaintenanceInfo.objectId = routineMaintenance.objectId;
        return routineMaintenanceInfo;
      }).toList());
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

  void addNewRoutineMaintenance() {
    final routineMaintenanceInfo = RoutineMaintenanceInfo();
    routineMaintenanceInfo.isNew = true;
    _routineMaintenances.add(routineMaintenanceInfo);
    notifyListeners();
  }

  bool trySaveRoutineMaintenance({
    required BuildContext context,
    int? index,
  }) {
    if (index == null || index >= _routineMaintenances.length) return false;
    final routineMaintenanceInfo = _routineMaintenances[index];

    List<String> _errorList = [];

    final vehicleNodeIndex = routineMaintenanceInfo.vehicleNodeIndex;
    final title = routineMaintenanceInfo.titleTextController.text.trim();
    final periodicityString =
        routineMaintenanceInfo.periodicityTextController.text.trim();

    if (title.isEmpty) {
      _errorList.add('Поле "Название" не может быть пустым.');
    }

    if (periodicityString.isEmpty) {
      _errorList.add('Поле "Периодичность" не может быть пустым.');
    } else {
      final periodicityTryParse = int.tryParse(periodicityString);
      if (periodicityTryParse == null) {
        _errorList.add('Введите целое число в поле "Периодичность".');
      }
    }

    if (vehicleNodeIndex < 0) {
      _errorList.add('Выберите узел транспортного средства.');
    }

    if (_errorList.isNotEmpty) {
      _isLoadingProgress = false;
      notifyListeners();
      String _errorMessage = '';
      for (var i = 0; i < _errorList.length; i++) {
        _errorMessage += '${i + 1}) ${_errorList[i]}\n';
      }
      ErrorDialogWidget.showErrorWithMessage(context, _errorMessage);
      return false;
    }

    _routineMaintenances[index].isSaved = true;
    if (_routineMaintenances[index].objectId != null) {
      _routineMaintenances[index].isUpdated = true;
    }
    return true;
  }

  Future<void> saveToDatabase(BuildContext context) async {
    _isLoadingProgress = true;
    notifyListeners();
    List<String> _errorList = [];
    int mileage = 0;

    final model = modelTextControler.text.trim();
    final mileageString = mileageTextController.text.trim();
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

    if (selectedVehicleTypeIndex < 0) {
      _errorList.add('Выберите тип транспортного средства.');
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
      String? vehicleId;
      if (_vehicleId == '') {
        final imageFile = _imageService.imageFileList?.first;
        vehicleId = await _vehicleService.createVehicle(
          model: model,
          mileage: mileage,
          vehicleType: selectedVehicleTypeIndex,
          licensePlate: licensePlate,
          description: description,
          image: imageFile,
        );
      } else {
        await _imageService.deleteImagesFromServer(imageIDToDelete);
        for (var id in imageIDToDelete) {
          _vehicle?.imageIdUrl.remove(id);
        }
        await _vehicleService.updateVehicle(
          vehicleId: _vehicleId,
          model: model == _vehicle?.model ? null : model,
          mileage: mileage == _vehicle?.mileage ? null : mileage,
          vehicleType: selectedVehicleTypeIndex == _vehicle?.vehicleType
              ? null
              : selectedVehicleTypeIndex,
          licensePlate:
              licensePlate == _vehicle?.licensePlate ? null : licensePlate,
          description:
              description == _vehicle?.description ? null : description,
          image: _imageService.imageFileList?.first,
        );
        vehicleId = _vehicleId;
      }
      if (vehicleId != null) {
        final routineMaintenanceService = RoutineMaintenanceService(vehicleId);
        for (var objectId in _routineMaintenancesIdToDelete) {
          await _routineMaintenanceService.deleteRoutineMaintenance(objectId);
        }
        for (var routineMaintenanceInfo in _routineMaintenances) {
          if (routineMaintenanceInfo.isSaved) {
            if (routineMaintenanceInfo.isNew) {
              await routineMaintenanceService.createRoutineMaintenance(
                title: routineMaintenanceInfo.titleTextController.text,
                periodicity: int.tryParse(routineMaintenanceInfo
                        .periodicityTextController.text) ??
                    0,
                engineHoursValue: 0,
                vehicleNode: VehicleNodeNames.getNameByIndex(
                    routineMaintenanceInfo.vehicleNodeIndex),
              );
            } else if (routineMaintenanceInfo.isUpdated &&
                routineMaintenanceInfo.objectId != null) {
              await routineMaintenanceService.updateRoutineMaintenance(
                objectId: routineMaintenanceInfo.objectId!,
                title: routineMaintenanceInfo.titleTextController.text,
                periodicity: int.tryParse(routineMaintenanceInfo
                        .periodicityTextController.text) ??
                    0,
                vehicleNode: VehicleNodeNames.getNameByIndex(
                    routineMaintenanceInfo.vehicleNodeIndex),
              );
            }
          }
        }
        final hoursInfo = await routineMaintenanceService
            .getVehicleRoutineMaintenanceHoursInfo();
        final vehicle = await _vehicleService.getVehicleFromHive(
            vehicleObjectId: vehicleId);
        if (hoursInfo != vehicle?.hoursInfo) {
          bool doResetHoursInfo = false;
          if (hoursInfo == null) {
            doResetHoursInfo = true;
          }
          await _vehicleService.updateVehicle(
            vehicleId: vehicleId,
            hoursInfo: hoursInfo,
            doResetRoutineMaintenanceInfo: doResetHoursInfo,
          );
        }
        routineMaintenanceService.dispose();
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

  void setSelectedVehiicleTypeIndex(int index) {
    selectedVehicleTypeIndex = index;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _vehicleService.dispose();
    await _routineMaintenanceService.dispose();
    super.dispose();
  }
}

class VehicleTypeWidgetConfiguration {
  final VehicleTypeCard vehicleCard;
  final bool isPicked;
  late Color color;
  late double borderWidth;

  VehicleTypeWidgetConfiguration({
    required this.vehicleCard,
    required this.isPicked,
  }) {
    color = isPicked ? AppColors.blue : AppColors.greyText;
    borderWidth = isPicked ? 1.5 : 1.0;
  }
}

class VehicleTypeCard {
  final String iconName;
  final String title;
  VehicleTypeCard({
    required this.iconName,
    required this.title,
  });

  static final vehicleTypeCardsConfiguration = [
    VehicleTypeCard(
      iconName: AppSvgs.passengerCar,
      title: 'Легковой автомобиль',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.lowTonnageTruck,
      title: 'Малотоннажный грузовик',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.mediumTonnageTruck,
      title: 'Среднетоннажный грузовик',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.miniLoader,
      title: 'Мини-погрузчик',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.excavator,
      title: 'Экскаватор',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.cementMixer,
      title: 'Бетоновоз',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.truckCrane,
      title: 'Манипулятор и автокран',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.dumpTruck,
      title: 'Самосвал и тонар',
    ),
    VehicleTypeCard(
      iconName: AppSvgs.other,
      title: 'Другое',
    ),
  ];
}

class RoutineMaintenanceInfo {
  int vehicleNodeIndex = -1;
  final titleTextController = TextEditingController();
  final periodicityTextController = TextEditingController();
  bool isSaved = false;
  bool isNew = false;
  bool isUpdated = false;
  String? objectId;

  void setVehiicleNodeIndex(int index) {
    vehicleNodeIndex = index;
    notifyAboutChanges();
  }

  void notifyAboutChanges() {
    isSaved = false;
  }
}

class RoutineMaintenanceWidgetConfiguration {
  late int selectedIndex;
  late TextEditingController titleTextController;
  late TextEditingController periodicityTextController;
  late String iconName;
  late String title;
  late Color color;
  late IconData arrowIcon;
  late void Function(int) setVehicleNode;
  late void Function() notifyAboutChanges;
  RoutineMaintenanceWidgetConfiguration(
      RoutineMaintenanceInfo routineMaintenanceInfo, bool isActive) {
    selectedIndex = routineMaintenanceInfo.vehicleNodeIndex;
    titleTextController = routineMaintenanceInfo.titleTextController;
    periodicityTextController =
        routineMaintenanceInfo.periodicityTextController;
    arrowIcon = isActive
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    if (routineMaintenanceInfo.isSaved) {
      final vehicleNode = VehicleNodeNames.getNameByIndex(
          routineMaintenanceInfo.vehicleNodeIndex);
      iconName = VehicleNodeNames.getIconName(vehicleNode);
      color = isActive ? AppColors.blue : AppColors.black;
      title = routineMaintenanceInfo.titleTextController.text;
    } else {
      iconName = AppSvgs.significantBreakage;
      color = AppColors.yellow;
      title = 'Сохраните изменения, нажав кнопку "ОК"';
    }
    setVehicleNode = routineMaintenanceInfo.setVehiicleNodeIndex;
    notifyAboutChanges = routineMaintenanceInfo.notifyAboutChanges;
  }
}
