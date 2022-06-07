import 'dart:async';

import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/completed_repair_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class RepairHistoryViewModel extends ChangeNotifier {
  late final _completedRepairService = CompletedRepairService(_vehicleObjectId);

  bool isLoadingProgress = false;
  List<CompletedRepair> _completedRepairList = [];

  final String _vehicleObjectId;
  RepairHistoryViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getCompletedRepairList(context);
    subscribeToCompletedRepairBox(context);
  }

  Stream<BoxEvent>? completedRepairStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToCompletedRepairBox(BuildContext context) async {
    completedRepairStream =
        await _completedRepairService.getCompletedRepairStream();
    subscription = completedRepairStream?.listen((event) {
      _getCompletedRepairList(context);
    });
  }

  int get completedRepairListLength => _completedRepairList.length;
  CompletedRepairCardWidgetConfiguration?
      getCompletedRepairCardWidgetConfiguration(int index) {
    if (index < _completedRepairList.length) {
      return CompletedRepairCardWidgetConfiguration(
          _completedRepairList[index]);
    }
  }

  Future<void> _getCompletedRepairList(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _completedRepairList =
          await _completedRepairService.getVehicleCompletedRepairsFromHive();
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

  @override
  Future<void> dispose() async {
    await _completedRepairService.dispose();
    await subscription?.cancel();
    super.dispose();
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
