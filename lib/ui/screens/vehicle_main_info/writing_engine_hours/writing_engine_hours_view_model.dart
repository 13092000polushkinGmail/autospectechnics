import 'dart:async';

import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WritingEngineHoursViewModel extends ChangeNotifier {
  //TODO Надо подписаться на vehicleBox, чтобы в случае обновления пробега тачки, менялось значение и здесь
  final _vehicleService = VehicleService();
  late final _routineMaintenanceService =
      RoutineMaintenanceService(_vehicleObjectId);

  int _engineHoursValue = 1;
  bool isLoadingProgress = false;
  final mileageTextController = TextEditingController();
  Vehicle? _vehicle;

  final String _vehicleObjectId;
  WritingEngineHoursViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getVehicle(context);
    subscribeToVehicleBox(context);
  }

  int get engineHoursValue => _engineHoursValue;

  Stream<BoxEvent>? vehicleStream;
  StreamSubscription<BoxEvent>? vehicleSubscription;
  Future<void> subscribeToVehicleBox(BuildContext context) async {
    vehicleStream = await _vehicleService.getVehicleStream();
    vehicleSubscription = vehicleStream?.listen((event) {
      _getVehicle(context);
    });
  }

  Future<void> _getVehicle(BuildContext context) async {
    try {
      _vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      mileageTextController.text = _vehicle?.mileage.toString() ?? '';
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

  Future<void> saveToDatabase(BuildContext context) async {
    List<String> _errorList = [];
    int mileage = 0;

    final mileageString = mileageTextController.text.trim();

    if (mileageString.isEmpty) {
      _errorList.add('Поле "Текущий пробег" не может быть пустым.');
    } else {
      final mileageTryParse = int.tryParse(mileageString);
      if (mileageTryParse == null) {
        _errorList.add('Введите целое число в поле "Пробег".');
      } else {
        mileage = mileageTryParse;
      }
    }

    if (_errorList.isNotEmpty) {
      String _errorMessage = '';
      for (var i = 0; i < _errorList.length; i++) {
        _errorMessage += '${i + 1}) ${_errorList[i]}\n';
      }
      ErrorDialogWidget.showErrorWithMessage(context, _errorMessage);
      return;
    }

    isLoadingProgress = true;
    notifyListeners();

    try {
      final vehicleHoursInfo = _vehicle?.hoursInfo;
      int? mileageToSave;
      if (mileage != _vehicle?.mileage) {
        mileageToSave = mileage;
      }
      RoutineMaintenanceHoursInfo? newHoursInfo;
      if (vehicleHoursInfo != null) {
        if (_engineHoursValue != 0) {
          final newEngineHours =
              vehicleHoursInfo.engineHoursValue + _engineHoursValue;
          newHoursInfo = RoutineMaintenanceHoursInfo(
              periodicity: vehicleHoursInfo.periodicity,
              engineHoursValue: newEngineHours);
          await _routineMaintenanceService
              .addEngineHoursToVehicleRoutineMaintenances(
                  additionalEngineHours: _engineHoursValue);
        }
      }
      await _vehicleService.updateVehicle(
        vehicleId: _vehicleObjectId,
        mileage: mileageToSave,
        hoursInfo: newHoursInfo,
      );
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

    isLoadingProgress = false;
    notifyListeners();
  }

  void setEngineHoursValue(int value) {
    _engineHoursValue = value;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _vehicleService.dispose();
    super.dispose();
  }
}
