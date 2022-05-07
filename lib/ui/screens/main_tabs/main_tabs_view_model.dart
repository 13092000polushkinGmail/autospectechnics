import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:flutter/cupertino.dart';

import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';

class MainTabsViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();

  var _currentTabIndex = 0;
  bool _isLoadingProgress = false;
  List<Vehicle> _vehiclesList = [];
  List<VehicleWidgetConfiguration> _vehiclesWidgetConfigurationList = [];

  MainTabsViewModel(BuildContext context) {
    getVehicles(context);
  }

  int get currentTabIndex => _currentTabIndex;
  bool get isLoadingProgress => _isLoadingProgress;
  List<VehicleWidgetConfiguration> get vehiclesWidgetConfigurationList =>
      _vehiclesWidgetConfigurationList;

  Future<void> getVehicles(BuildContext context) async {
    _isLoadingProgress = true;
    notifyListeners();
    try {
      _vehiclesList = await _vehicleService.getAllVehicles();
      _vehiclesWidgetConfigurationList = _vehiclesList
          .map((Vehicle vehicle) =>
              VehicleWidgetConfiguration.getVehicleConfiguration(vehicle))
          .toList();
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

    _isLoadingProgress = false;
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

  void openObjectInfoScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.objectMainInfoScreen);
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
