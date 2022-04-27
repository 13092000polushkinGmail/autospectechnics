import 'dart:io';

import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/parse_exception.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class MainTabsViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();

  var _currentTabIndex = 0;
  bool _isLoadingProgress = false;
  List<Vehicle> _vehiclesList = [];

  MainTabsViewModel(BuildContext context) {
    getVehicles(context);
  }

  int get currentTabIndex => _currentTabIndex;
  bool get isLoadingProgress => _isLoadingProgress;
  List<Vehicle> get vehiclesList => _vehiclesList;

  Future<void> getVehicles(BuildContext context) async {
    _isLoadingProgress = true;
    notifyListeners();
    try {
      _vehiclesList = await _vehicleService.getAllVehicles();
      notifyListeners();
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
