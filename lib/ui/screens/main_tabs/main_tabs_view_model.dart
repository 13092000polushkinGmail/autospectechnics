import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/services/building_object_service.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';

class MainTabsViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();
  final _buildingObjectService = BuildingObjectService();

  var _currentTabIndex = 0;
  bool _isVehicleLoadingProgress = false;
  bool _isObjectLoadingProgress = false;

  List<Vehicle> _vehiclesList = [];
  List<ExtendedBuildingObject> _extendedBuildingObjectList = [];

  MainTabsViewModel(BuildContext context) {
    getAllInfo(context);
    subscribeToVehicleBox(context);
    subscribeToBuildingObjectBox(context);
  }

  int get currentTabIndex => _currentTabIndex;
  bool get isVehicleLoadingProgress => _isVehicleLoadingProgress;
  bool get isObjectLoadingProgress => _isObjectLoadingProgress;

  List<Vehicle> get vehiclesList => _vehiclesList;

  VehicleWidgetConfiguration? getVehicleWidgetConfiguration(int index) {
    if (index < _vehiclesList.length) {
      return VehicleWidgetConfiguration(_vehiclesList[index]);
    }
  }

  List<ExtendedBuildingObject> get buildingObjectList =>
      _extendedBuildingObjectList;

  BuildingObjectWidgetConfiguration? getBuildingObjectWidgetConfiguration(
      int index) {
    if (index < _extendedBuildingObjectList.length) {
      return BuildingObjectWidgetConfiguration(
        extendedBuildingObject: _extendedBuildingObjectList[index],
      );
    }
  }

  Stream<BoxEvent>? vehicleStream;
  StreamSubscription<BoxEvent>? vehicleSubscription;
  Future<void> subscribeToVehicleBox(BuildContext context) async {
    vehicleStream = await _vehicleService.getVehicleStream();
    vehicleSubscription = vehicleStream?.listen((event) {
      getDataFromHive(context);
    });
  }

  Stream<BoxEvent>? buildingObjectStream;
  StreamSubscription<BoxEvent>? buildingObjectSubscription;
  Future<void> subscribeToBuildingObjectBox(BuildContext context) async {
    buildingObjectStream =
        await _buildingObjectService.getBuildingObjectStream();
    buildingObjectSubscription = buildingObjectStream?.listen((event) {
      getBuildingObjectList(context);
    });
  }

  //TODO Подписаться на VehicleBuildingObject, чтобы при редактировании объекта и изменении техники, используемой на нем, обновлять список объектов.
  //Нужно видимо оформлять подписку на бокс каждого объекта.
  // Stream<BoxEvent>? vehicleBuildingObjectStream;
  // StreamSubscription<BoxEvent>? vehicleBuildingObjectSubscription;
  // Future<void> subscribeToVehicleBuildingObjectBox(BuildContext context) async {
  //   vehicleBuildingObjectStream =
  //       await _vehicleBuildingObjectService.getVehicleBuildingObjectStream();
  //   vehicleBuildingObjectSubscription =
  //       vehicleBuildingObjectStream?.listen((event) {
  //     getBuildingObjectInfo(context);
  //   });
  // }

  Future<void> getAllInfo(BuildContext context) async {
    if (_isVehicleLoadingProgress || _isObjectLoadingProgress) return;
    _isVehicleLoadingProgress = true;
    _isObjectLoadingProgress = true;
    notifyListeners();
    final stopwatch = Stopwatch()..start();
    await getDataFromHive(context);
    await downloadData(context);
    stopwatch.stop();
    print('ЗАГРУЗКА ГЛАВНОГО ЭКРАНА ${stopwatch.elapsed}');
  }

  Future<void> getDataFromHive(BuildContext context) async {
    await getVehiclesList(context);
    await getBuildingObjectList(context);
  }

  Future<void> getVehiclesList(BuildContext context) async {
    try {
      _vehiclesList = await _vehicleService.getAllVehiclesFromHive();
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

  Future<void> getBuildingObjectList(BuildContext context) async {
    try {
      final buildingObjectList =
          await _buildingObjectService.getBuildingObjectsListFromHive();
      final extendedBuildingObjectList = <ExtendedBuildingObject>[];
      for (var buildingObject in buildingObjectList) {
        final vehicleStatus = await _buildingObjectService
            .getBuildingObjectVehicleStatus(buildingObject.objectId);
        extendedBuildingObjectList
            .add(ExtendedBuildingObject(buildingObject, vehicleStatus));
      }
      _extendedBuildingObjectList = extendedBuildingObjectList;
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

  Future<void> downloadData(BuildContext context) async {
    await downloadVehicles(context);
    await downloadObjects(context);
  }

  Future<void> downloadVehicles(BuildContext context) async {
    final stopwatch = Stopwatch()..start();
    try {
      final vehiclesFromServer = await _vehicleService.downloadAllVehicles();
      for (var vehicle in vehiclesFromServer) {
        final routineMaintenanceService =
            RoutineMaintenanceService(vehicle.objectId);
        await routineMaintenanceService.downloadVehicleRoutineMaintenanceList();
        final hoursInfo = await routineMaintenanceService
            .getVehicleRoutineMaintenanceHoursInfo();
        vehicle.hoursInfo = hoursInfo;
        await _vehicleService.putVehicleToHive(vehicle);
        await routineMaintenanceService.dispose();
      }
      _vehiclesList = await _vehicleService.getAllVehiclesFromHive();
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

    _isVehicleLoadingProgress = false;
    notifyListeners();
    stopwatch.stop();
    print('СКАЧИВАНИЕ СПИСКА АВТОМОБИЛЕЙ ${stopwatch.elapsed}');
  }

  Future<void> downloadObjects(BuildContext context) async {
    try {
      await _buildingObjectService.downloadBuildingObjects();
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

    _isObjectLoadingProgress = false;
    notifyListeners();
  }

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }

  void openAddingVehicleScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingVehicleScreen);
  }

  void openVehicleInfoScreen(BuildContext context, int index) {
    final vehicleObjectId = _vehiclesList[index].objectId;
    Navigator.of(context).pushNamed(
        MainNavigationRouteNames.vehicleMainInfoScreen,
        arguments: vehicleObjectId);
  }

  void openObjectInfoScreen(BuildContext context, int index) {
    final buildingObjectId =
        _extendedBuildingObjectList[index].buildingObject.objectId;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.objectMainInfoScreen,
      arguments: buildingObjectId,
    );
  }

  void openAddingObjectScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingObjectScreen);
  }

  @override
  Future<void> dispose() async {
    await _vehicleService.dispose();
    await _buildingObjectService.dispose();
    vehicleSubscription?.cancel();
    buildingObjectSubscription?.cancel();
    super.dispose();
  }
}

class VehicleWidgetConfiguration {
  late String model;
  late String breakageIcon;
  late String remainingEngineHours;
  double? progressBarValue;
  String? vehicleImageURL;

  VehicleWidgetConfiguration(Vehicle vehicle) {
    model = vehicle.model;
    breakageIcon = BreakageDangerLevel(vehicle.breakageDangerLevel).iconName;
    final hoursInfo = vehicle.hoursInfo;
    if (hoursInfo != null) {
      final intRemainingEngineHours =
          hoursInfo.periodicity - hoursInfo.engineHoursValue;
      remainingEngineHours = '$intRemainingEngineHours м.ч.';
      progressBarValue = intRemainingEngineHours / hoursInfo.periodicity;
    }
    final url = vehicle.imageIdUrl.values.toList();
    if (url.isNotEmpty) {
      vehicleImageURL = url.first;
    }
  }
}

class BuildingObjectWidgetConfiguration {
  late String title;
  String? breakageIcon;
  DaysInfo? daysInfo;
  String? buildingObjectImageURL;
  BuildingObjectWidgetConfiguration({
    required ExtendedBuildingObject extendedBuildingObject,
  }) {
    final buildingObject = extendedBuildingObject.buildingObject;
    final vehicleStatus = extendedBuildingObject.vehicleStatus;
    title = buildingObject.title;
    if (vehicleStatus >= -1) {
      breakageIcon = BreakageDangerLevel(vehicleStatus).iconName;
    }
    daysInfo = DateFormatter.getDaysInfo(
        buildingObject.startDate, buildingObject.finishDate);
    if (buildingObject.imagesIdUrl.isNotEmpty) {
      buildingObjectImageURL = buildingObject.imagesIdUrl.values.first;
    }
  }
}

class ExtendedBuildingObject {
  final BuildingObject buildingObject;
  final int vehicleStatus;

  ExtendedBuildingObject(this.buildingObject, this.vehicleStatus);
}
