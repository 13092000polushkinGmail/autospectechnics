import 'dart:async';

import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/parse_database_string_names/vehicle_node_names.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/confirm_dialog_widget.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/breakage_details_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BreakageDetailsViewModel extends ChangeNotifier {
  late final _breakageService = BreakageService(_vehicleObjectId);
  late final _completedRepairService = CompletedRepairService(_vehicleObjectId);

  final _vehicleService = VehicleService();

  Breakage? _breakage;
  bool isLoadingProgress = false;
  bool isUpdatingProgress = false;

  final String _vehicleObjectId;
  final String _breakageObjectId;
  BreakageDetailsViewModel(
    this._vehicleObjectId,
    this._breakageObjectId,
    BuildContext context,
  ) {
    _getBreakage(context);
    subscribeToBreakageBox(context);
  }

  Stream<BoxEvent>? breakageStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToBreakageBox(BuildContext context) async {
    breakageStream = await _breakageService.getBreakageStream();
    subscription = breakageStream?.listen((event) {
      _getBreakage(context);
    });
  }

  BreakageWidgetConfiguration get breakageWidgetConfiguration =>
      BreakageWidgetConfiguration(_breakage);

  Future<void> _getBreakage(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _breakage = await _breakageService.getBreakageFromHive(_breakageObjectId);
      if (_breakage == null) {
        ErrorDialogWidget.showDataSyncingError(context);
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

  Future<void> fixBreakage(BuildContext context) async {
    final isConfirmed = await ConfirmDialogWidget.isConfirmed(context: context);
    if (!isConfirmed) {
      return;
    }
    isUpdatingProgress = true;
    notifyListeners();
    try {
      final breakage = _breakage;
      final vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      if (breakage == null || vehicle == null) {
        isUpdatingProgress = false;
        notifyListeners();
        return;
      }
      final breakageId = breakage.objectId;
      await _completedRepairService.createCompletedRepair(
        title: 'Устранение поломки: ${breakage.title}',
        mileage: vehicle.mileage,
        description: breakage.description,
        date: DateTime.now(),
        vehicleNode: breakage.vehicleNode,
        breakageObjectId: breakageId,
      );
      await _breakageService.fixBreakage(breakageId);
      final vehicleBreakageDangerLevel =
          await _breakageService.getVehicleDangerLevel();
      if (vehicle.breakageDangerLevel != vehicleBreakageDangerLevel) {
        await _vehicleService.updateVehicle(
            vehicleId: vehicle.objectId,
            breakageDangerLevel: vehicleBreakageDangerLevel);
      }
      Navigator.pop(context);
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
    isUpdatingProgress = false;
    notifyListeners();
  }

  Future<void> onDeleteButtonTap(BuildContext context) async {
    final isConfirmed = await ConfirmDialogWidget.isConfirmed(context: context);
    if (!isConfirmed) return;
    try {
      await _breakageService.deleteBreakage(_breakageObjectId);
      Navigator.of(context).pop();
      final vehicleBreakageDangerLevel =
          await _breakageService.getVehicleDangerLevel();
      final vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      if (vehicle?.breakageDangerLevel != vehicleBreakageDangerLevel) {
        await _vehicleService.updateVehicle(
            vehicleId: _vehicleObjectId,
            breakageDangerLevel: vehicleBreakageDangerLevel);
      }
      Navigator.of(context).pop();
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
  }

  void openUpdatingBreakageScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingBreakageScreen,
      arguments: BreakageDetailsArgumentsConfiguration(
        vehicleObjectId: _vehicleObjectId,
        breakageObjectId: _breakageObjectId,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _breakageService.dispose();
    await _completedRepairService.dispose();
    await _vehicleService.dispose();
    await subscription?.cancel();
    super.dispose();
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
    photosURL = breakage?.imagesIdUrl.values.toList() ?? [];
    description = breakage?.description ?? '';
  }
}
