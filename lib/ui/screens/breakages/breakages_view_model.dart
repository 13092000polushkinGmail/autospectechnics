import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class BreakagesViewModel extends ChangeNotifier {
  final String _vehicleObjectId;
  final _breakageService = BreakageService();
  bool isLoadingProgress = false;

  BreakagesViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getBreakageList(context);
  }

  List<Breakage> _breakageList = [];
  List<Breakage> get breakageList => List.unmodifiable(_breakageList);

  BreakageCardWidgetConfiguration getBreakageCardWidgetConfiguration(
          int index) =>
      BreakageCardWidgetConfiguration(_breakageList[index]);

  Future<void> _getBreakageList(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _breakageList = await _breakageService.getVehicleBreakages(
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

  void openBreakageDetailsScreen(
    BuildContext context,
    int index,
  ) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.breakageDetailsScreen,
      arguments: _breakageList[index].objectId,
    );
  }

  void openAddingBreakageScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingBreakageScreen,
      arguments: _vehicleObjectId,
    );
  }
}

class BreakageCardWidgetConfiguration {
  late String vehicleNodeIconName;
  late String title;
  late String dangerLevelIconName;
  late String dangerLevel;
  BreakageCardWidgetConfiguration(Breakage breakage) {
    vehicleNodeIconName = VehicleNodeNames.getIconName(breakage.vehicleNode);
    title = breakage.title;
    final breakageDangerLevel = BreakageDangerLevel(breakage.dangerLevel);
    dangerLevelIconName = breakageDangerLevel.iconName;
    dangerLevel = 'Уровень: ${breakageDangerLevel.name}';
  }
}
