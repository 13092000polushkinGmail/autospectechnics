import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

class CompletedRepairViewModel extends ChangeNotifier {
  final String _vehicleObjectId;
  final String _completedRepairObjectId;
  final _completedRepairService = CompletedRepairService();
  late final _breakageService = BreakageService(_vehicleObjectId);
  CompletedRepair? _completedRepair;
  Breakage? _breakage;
  bool isLoadingProgress = false;

  CompletedRepairViewModel(
    this._vehicleObjectId,
    this._completedRepairObjectId,
    BuildContext context,
  ) {
    _getCompletedRepair(context);
  }

  CompletedRepairWidgetConfiguration get completedRepairWidgetConfiguration =>
      CompletedRepairWidgetConfiguration(_completedRepair);
  BreakageWidgetConfiguration get breakageWidgetConfiguration =>
      BreakageWidgetConfiguration(_breakage);

  Future<void> _getCompletedRepair(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _completedRepair =
          await _completedRepairService.geCompletedRepairFromHive(
              _completedRepairObjectId, _vehicleObjectId);

      final breakageObjectId = _completedRepair?.breakageObjectId;

      if (breakageObjectId != null && breakageObjectId.isNotEmpty) {
        _breakage =
            await _breakageService.getBreakageFromHive(breakageObjectId);
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
    isLoadingProgress = false;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _breakageService.dispose();
    super.dispose();
  }
}

class CompletedRepairWidgetConfiguration {
  late String vehicleNodeIconName;
  late String title;
  late String date;
  late String mileage;
  late String description;
  late List<String> photosURL;
  CompletedRepairWidgetConfiguration(CompletedRepair? completedRepair) {
    final vehicleNode = completedRepair?.vehicleNode ?? '';
    vehicleNodeIconName = VehicleNodeNames.getIconName(vehicleNode);
    title = completedRepair?.title ?? 'Данные не получены. Обновите страницу';
    final fullDate = completedRepair?.date.toString();
    date = fullDate != null
        ? '${fullDate.substring(8, 10)}.${fullDate.substring(5, 7)}.${fullDate.substring(0, 4)}'
        : '';
    final intMileage = completedRepair?.mileage;
    mileage = intMileage != null ? '${completedRepair?.mileage} км.' : '';
    description = completedRepair?.description ?? '';
    photosURL = completedRepair?.photosURL ?? [];
  }
}

class BreakageWidgetConfiguration {
  late String vehicleNodeIconName;
  late String title;
  late String dangerLevelIconName;
  late String dangerLevel;
  late List<String> photosURL;
  late String description;
  BreakageWidgetConfiguration(Breakage? breakage) {
    final vehicleNode = breakage?.vehicleNode ?? '';
    vehicleNodeIconName = VehicleNodeNames.getIconName(vehicleNode);
    title = breakage?.title ?? 'Данные не получены.';

    final intDangerLevel = breakage?.dangerLevel;
    if (intDangerLevel == null) {
      dangerLevelIconName = AppSvgs.significantBreakage;
      dangerLevel = 'Что-то пошло не так. Обновите страницу';
    } else {
      final breakageDangerLevel = BreakageDangerLevel(intDangerLevel);
      dangerLevelIconName = breakageDangerLevel.iconName;
      dangerLevel = 'Уровень: ${breakageDangerLevel.name}';
    }
    photosURL = breakage?.photosURL ?? [];
    description = breakage?.description ?? '';
  }
}
