import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';

class RoutineMaintenanceViewModel extends ChangeNotifier {
  final String _vehicleObjectId;
  final _routineMaintenanceService = RoutineMaintenanceService();

  bool isDataLoading = false;
  bool isRoutineMaintenanceUpdating = false;

  final List<RoutineMaintenance> _engineWorkList = [];
  final List<RoutineMaintenance> _bodyworkWorkList = [];
  final List<RoutineMaintenance> _transmissionWorkList = [];
  final List<RoutineMaintenance> _chassisWorkList = [];
  final List<RoutineMaintenance> _technicalLiquidsWorkList = [];
  final List<RoutineMaintenance> _otherNodesWorkList = [];

  final List<VehicleNodeDataWidgetConfiguration> _vehicleNodeDataList = [];

  RoutineMaintenanceViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    getRoutineMaintenanceList(context);
  }

  List<VehicleNodeDataWidgetConfiguration> get vehicleNodeDataList =>
      List.unmodifiable(_vehicleNodeDataList);

  Future<void> getRoutineMaintenanceList(BuildContext context) async {
    isDataLoading = true;
    notifyListeners();
    try {
      final routineMaintenanceList = await _routineMaintenanceService
          .getVehicleRoutineMaintenancesFromHive(
              vehicleObjectId: _vehicleObjectId);

      for (var routineMaintenance in routineMaintenanceList) {
        final vehicleNode = routineMaintenance.vehicleNode;
        switch (vehicleNode) {
          case 'Engine':
            _engineWorkList.add(routineMaintenance);
            break;
          case 'Bodywork':
            _bodyworkWorkList.add(routineMaintenance);
            break;
          case 'Transmission':
            _transmissionWorkList.add(routineMaintenance);
            break;
          case 'Chassis':
            _chassisWorkList.add(routineMaintenance);
            break;
          case 'Technical liquids':
            _technicalLiquidsWorkList.add(routineMaintenance);
            break;
          case 'Other nodes':
            _otherNodesWorkList.add(routineMaintenance);
            break;
        }
      }

      if (_engineWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.engine,
              title: 'ДВС',
              routineMaintenanceList: _engineWorkList),
        );
      }

      if (_bodyworkWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.bodywork,
              title: 'Кузов',
              routineMaintenanceList: _bodyworkWorkList),
        );
      }

      if (_transmissionWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.transmission,
              title: 'КПП',
              routineMaintenanceList: _transmissionWorkList),
        );
      }

      if (_chassisWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.chassis,
              title: 'Ходовая',
              routineMaintenanceList: _chassisWorkList),
        );
      }

      if (_technicalLiquidsWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.technicalLiquids,
              title: 'Технические жидкости',
              routineMaintenanceList: _technicalLiquidsWorkList),
        );
      }

      if (_otherNodesWorkList.isNotEmpty) {
        _vehicleNodeDataList.add(
          VehicleNodeDataWidgetConfiguration(
              iconName: AppSvgs.otherNodes,
              title: 'Прочие узлы',
              routineMaintenanceList: _otherNodesWorkList),
        );
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

  Future<void> resetEngineHoursValue({
    required String routineMaintenanceObjectId,
    required int vehicleNodeDataIndex,
    required int routineMaintenanceIndex,
    required BuildContext context,
  }) async {
    isRoutineMaintenanceUpdating = true;
    notifyListeners();
    try {
      await _routineMaintenanceService.resetEngineHoursValue(
          routineMaintenanceObjectId: routineMaintenanceObjectId);

      _vehicleNodeDataList[vehicleNodeDataIndex]
          .routineMaintenanceList[routineMaintenanceIndex]
          .engineHoursValue = 0;
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
    isRoutineMaintenanceUpdating = false;
    notifyListeners();
  }

  void openWritingEngineHoursScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.writingEngineHoursScreen);
  }
}

class VehicleNodeDataWidgetConfiguration {
  final String iconName;
  final String title;
  final List<RoutineMaintenance> routineMaintenanceList;

  VehicleNodeDataWidgetConfiguration({
    required this.iconName,
    required this.title,
    required this.routineMaintenanceList,
  });
}
