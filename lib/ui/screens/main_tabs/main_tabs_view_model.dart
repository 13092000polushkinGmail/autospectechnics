import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/services/building_object_service.dart';
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

  List<BuildingObject> _buildingObjectList = [];
  List<BuildingObjectWidgetConfiguration>
      _buildingObjectWidgetConfigurationList = [];

  MainTabsViewModel(BuildContext context) {
    getData(context);
  }

  int get currentTabIndex => _currentTabIndex;
  bool get isVehicleLoadingProgress => _isVehicleLoadingProgress;
  bool get isObjectLoadingProgress => _isObjectLoadingProgress;
  List<VehicleWidgetConfiguration> get vehiclesWidgetConfigurationList =>
      _vehiclesList
          .map((Vehicle vehicle) =>
              VehicleWidgetConfiguration.getVehicleConfiguration(vehicle))
          .toList();
  List<BuildingObjectWidgetConfiguration>
      get buildingObjectWidgetConfigurationList =>
          _buildingObjectWidgetConfigurationList;

  Future<void> getData(BuildContext context) async {
    _vehiclesList = await _vehicleService.getAllVehiclesFromHive();
    notifyListeners();
    _buildingObjectList =
        await _buildingObjectService.getBuildingObjectsListFromHive();
    await _updateBuildingObjectWidgetConfigurationList();
    notifyListeners();
    await downloadVehicles(context);
    await downloadObjects(context);
  }

  Future<void> downloadVehicles(BuildContext context) async {
    _isVehicleLoadingProgress = true;
    _isObjectLoadingProgress =
        true; //В этом методе потому что загрузка объектов начинается после загрузки техники
    notifyListeners();
    try {
      _vehiclesList = await _vehicleService.downloadAllVehicles();
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

    _isVehicleLoadingProgress = false;
    notifyListeners();
  }

  Future<void> _updateBuildingObjectWidgetConfigurationList() async {
    _buildingObjectWidgetConfigurationList.clear();
    for (BuildingObject buildingObject in _buildingObjectList) {
      final buildingObjectVehicleStatus = await _buildingObjectService
          .getBuildingObjectVehicleStatus(buildingObject.objectId);
      _buildingObjectWidgetConfigurationList
          .add(BuildingObjectWidgetConfiguration(
        buildingObject: buildingObject,
        buildingObjectVehicleStatus: buildingObjectVehicleStatus,
      ));
    }
  }

  Future<void> downloadObjects(BuildContext context) async {
    // _isObjectLoadingProgress = true;
    // notifyListeners();
    try {
      _buildingObjectList =
          await _buildingObjectService.downloadBuildingObjects();
      await _updateBuildingObjectWidgetConfigurationList();
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
    final buildingObjectId = _buildingObjectList[index].objectId;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.objectMainInfoScreen,
      arguments: buildingObjectId,
    );
  }

  void openAddingObjectScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingObjectScreen);
  }
}

class VehicleWidgetConfiguration {
  final String model;
  final String breakageIcon;
  final int? remainingEngineHours;
  final double? progressBarValue;
  final String? vehicleImageURL;
  VehicleWidgetConfiguration({
    required this.model,
    required this.breakageIcon,
    this.remainingEngineHours,
    this.progressBarValue,
    this.vehicleImageURL,
  });

  static VehicleWidgetConfiguration getVehicleConfiguration(Vehicle vehicle) {
    String breakageIcon =
        BreakageDangerLevel(vehicle.breakageDangerLevel).iconName;
    int? remainingEngineHours;
    double? progressBarValue;
    final hoursInfo = vehicle.hoursInfo;
    if (hoursInfo != null) {
      remainingEngineHours = hoursInfo.periodicity - hoursInfo.engineHoursValue;
      progressBarValue = remainingEngineHours / hoursInfo.periodicity;
    }
    return VehicleWidgetConfiguration(
        model: vehicle.model,
        breakageIcon: breakageIcon,
        remainingEngineHours: remainingEngineHours,
        progressBarValue: progressBarValue,
        vehicleImageURL: vehicle.imageURL);
  }
}

class BuildingObjectWidgetConfiguration {
  late String title;
  String? breakageIcon;
  late DaysInfo daysInfo;
  String? buildingObjectImageURL;
  BuildingObjectWidgetConfiguration({
    required BuildingObject buildingObject,
    required int buildingObjectVehicleStatus,
  }) {
    title = buildingObject.title;
    if (buildingObjectVehicleStatus >= -1) {
      breakageIcon = BreakageDangerLevel(buildingObjectVehicleStatus).iconName;
    }
    daysInfo = DateFormatter.getDaysInfo(
        buildingObject.startDate, buildingObject.finishDate);

    if (buildingObject.photosURL.isNotEmpty) {
      buildingObjectImageURL = buildingObject.photosURL.first;
    }
  }
}
