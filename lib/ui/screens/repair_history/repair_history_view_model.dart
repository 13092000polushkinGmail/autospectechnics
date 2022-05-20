import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/completed_repair_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class RepairHistoryViewModel extends ChangeNotifier {
  final String _vehicleObjectId;
  final _completedRepairService = CompletedRepairService();
  bool isLoadingProgress = false;

  RepairHistoryViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getCompletedRepairList(context);
  }

  List<CompletedRepair> _completedRepairList = [];
  List<CompletedRepair> get completedRepairList =>
      List.unmodifiable(_completedRepairList);

  CompletedRepairCardWidgetConfiguration
      getCompletedRepairCardWidgetConfiguration(int index) =>
          CompletedRepairCardWidgetConfiguration(_completedRepairList[index]);

  Future<void> _getCompletedRepairList(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _completedRepairList =
          await _completedRepairService.getVehicleCompletedRepairsFromHive(
              vehicleObjectId: _vehicleObjectId);
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

    isLoadingProgress = false;
    notifyListeners();
  }

  void openCompletedRepairScreen(
    BuildContext context,
    int index,
  ) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.completedRepairScreen,
      arguments: CompletedRepairArgumentsConfiguration(
          vehicleObjectId: _vehicleObjectId,
          completedRepairObjectId: _completedRepairList[index].objectId),
    );
  }

  void openAddingCompletedRepairScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingCompletedRepairScreen,
      arguments: _vehicleObjectId,
    );
  }
}

class CompletedRepairCardWidgetConfiguration {
  late String vehicleNodeIconName;
  late String title;
  late String date;
  late String mileage;
  CompletedRepairCardWidgetConfiguration(CompletedRepair completedRepair) {
    vehicleNodeIconName =
        VehicleNodeNames.getIconName(completedRepair.vehicleNode);
    title = completedRepair.title;
    final fullDate = completedRepair.date.toString();
    date =
        '${fullDate.substring(8, 10)}.${fullDate.substring(5, 7)}.${fullDate.substring(0, 4)}';
    mileage = '${completedRepair.mileage} км.';
  }
}
