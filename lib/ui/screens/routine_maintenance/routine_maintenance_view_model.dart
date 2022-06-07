import 'dart:async';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/adding_vehicle_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';

class RoutineMaintenanceViewModel extends ChangeNotifier {
  late final _routineMaintenanceService =
      RoutineMaintenanceService(_vehicleObjectId);
  final _vehicleService = VehicleService();

  bool isDataLoading = false;

  final Map<String, List<ExtendedRoutineMaintenance>> _vehicleNodeDataList = {};

  final String _vehicleObjectId;
  RoutineMaintenanceViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getRoutineMaintenanceList(context);
    subscribeToRoutineMaintenanceBox(context);
  }

  Stream<BoxEvent>? routineMaintenanceStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToRoutineMaintenanceBox(BuildContext context) async {
    routineMaintenanceStream =
        await _routineMaintenanceService.getRoutineMaintenanceStream();
    subscription = routineMaintenanceStream?.listen((event) {
      _getRoutineMaintenanceList(context);
    });
  }

  int get vehicleNodeAmount => _vehicleNodeDataList.length;

  VehicleNodeHeaderWidgetConfiguration? getVehicleNodeHeaderWidgetConfiguration(
      int index, bool isActive) {
    final keys = _vehicleNodeDataList.keys.toList();
    keys.sort();
    if (index < keys.length) {
      return VehicleNodeHeaderWidgetConfiguration(keys[index], isActive);
    }
  }

  List<ExtendedRoutineMaintenance>? getRoutineMaintenanceList(int index) {
    final keys = _vehicleNodeDataList.keys.toList();
    keys.sort();
    if (index < keys.length) {
      return _vehicleNodeDataList[keys[index]];
    }
  }

  WorkInfoWidgetConfiguration? getWorkInfoWidgetConfiguration(
      int index, int workIndex) {
    final keys = _vehicleNodeDataList.keys.toList();
    keys.sort();
    if (index < keys.length) {
      final routineMaintenanceList = _vehicleNodeDataList[keys[index]];
      if (routineMaintenanceList != null &&
          workIndex < routineMaintenanceList.length) {
        return WorkInfoWidgetConfiguration(routineMaintenanceList[workIndex]);
      }
    }
  }

  Future<void> _getRoutineMaintenanceList(BuildContext context) async {
    isDataLoading = true;
    notifyListeners();
    try {
      _vehicleNodeDataList.clear();

      final routineMaintenanceList = await _routineMaintenanceService
          .getVehicleRoutineMaintenancesFromHive();

      for (var routineMaintenance in routineMaintenanceList) {
        final vehicleNode = routineMaintenance.vehicleNode;
        if (_vehicleNodeDataList.containsKey(vehicleNode)) {
          _vehicleNodeDataList[vehicleNode]
              ?.add(ExtendedRoutineMaintenance(routineMaintenance));
        } else {
          _vehicleNodeDataList[vehicleNode] = [
            ExtendedRoutineMaintenance(routineMaintenance)
          ];
        }
      }
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
    isDataLoading = false;
    notifyListeners();
  }

  void openAddingVehicleScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingVehicleScreen,
      arguments: AddingVehicleArgumentsConfiguration(
        vehicleObjectId: _vehicleObjectId,
        pageIndex: 2,
      ),
    );
  }

  Future<void> resetEngineHoursValue({
    required int vehicleNodeDataIndex,
    required int routineMaintenanceIndex,
    required BuildContext context,
  }) async {
    final keys = _vehicleNodeDataList.keys.toList();
    keys.sort();

    if (vehicleNodeDataIndex > keys.length) return;
    final key = keys[vehicleNodeDataIndex];
    final routineMaintenaceList = _vehicleNodeDataList[key];
    if (routineMaintenaceList == null ||
        routineMaintenanceIndex > routineMaintenaceList.length) return;
    final routineMaintenanceObjectId =
        routineMaintenaceList[routineMaintenanceIndex]
            .routineMaintenance
            .objectId;
    _vehicleNodeDataList[key]?[routineMaintenanceIndex].isUpdating = true;
    notifyListeners();
    try {
      await _routineMaintenanceService.resetEngineHoursValue(
          routineMaintenanceObjectId: routineMaintenanceObjectId);
      final hoursInfo = await _routineMaintenanceService
          .getVehicleRoutineMaintenanceHoursInfo();
      final vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      if (hoursInfo != vehicle?.hoursInfo) {
        await _vehicleService.updateVehicle(
            vehicleId: _vehicleObjectId, hoursInfo: hoursInfo);
      }
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
    _vehicleNodeDataList[key]?[routineMaintenanceIndex].isUpdating = false;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _routineMaintenanceService.dispose();
    await _vehicleService.dispose();
    await subscription?.cancel();
    super.dispose();
  }
}

class VehicleNodeHeaderWidgetConfiguration {
  late String iconName;
  late String title;
  late Color color;
  late IconData arrowIcon;

  VehicleNodeHeaderWidgetConfiguration(String vehicleNode, bool isActive) {
    color = isActive ? AppColors.blue : AppColors.black;
    arrowIcon = isActive
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    switch (vehicleNode) {
      case 'Engine':
        iconName = AppSvgs.engine;
        title = 'ДВС';
        break;
      case 'Bodywork':
        iconName = AppSvgs.bodywork;
        title = 'Кузов';
        break;
      case 'Transmission':
        iconName = AppSvgs.transmission;
        title = 'КПП';
        break;
      case 'Chassis':
        iconName = AppSvgs.chassis;
        title = 'Ходовая';
        break;
      case 'Technical liquids':
        iconName = AppSvgs.technicalLiquids;
        title = 'Технические жидкости';
        break;
      case 'Other nodes':
        iconName = AppSvgs.otherNodes;
        title = 'Прочие узлы';
        break;
    }
  }
}

class WorkInfoWidgetConfiguration {
  late String title;
  late String engineHoursReserve;
  late double progressIndicatorValue;
  late bool isUpdating;
  WorkInfoWidgetConfiguration(
      ExtendedRoutineMaintenance extendedRoutineMaintenance) {
    final routineMaintenance = extendedRoutineMaintenance.routineMaintenance;
    title = routineMaintenance.title;
    final remainEngineHours =
        routineMaintenance.periodicity - routineMaintenance.engineHoursValue;
    engineHoursReserve =
        'Осталось $remainEngineHours/${routineMaintenance.periodicity} мч';
    progressIndicatorValue = remainEngineHours / routineMaintenance.periodicity;
    isUpdating = extendedRoutineMaintenance.isUpdating;
  }
}

class ExtendedRoutineMaintenance {
  final RoutineMaintenance routineMaintenance;
  bool isUpdating = false;

  ExtendedRoutineMaintenance(this.routineMaintenance);
}
