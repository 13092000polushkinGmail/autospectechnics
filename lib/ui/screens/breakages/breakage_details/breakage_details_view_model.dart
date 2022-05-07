import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';

class BreakageDetailsViewModel extends ChangeNotifier {
  final String _breakageObjectId;
  final _breakageService = BreakageService();
  Breakage? _breakage;
  bool isLoadingProgress = false;

  BreakageDetailsViewModel(
    this._breakageObjectId,
    BuildContext context,
  ) {
    _getBreakage(context);
  }

  BreakageWidgetConfiguration get breakageWidgetConfiguration =>
      BreakageWidgetConfiguration(_breakage);

  Future<void> _getBreakage(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _breakage = await _breakageService.getBreakage(_breakageObjectId);
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
