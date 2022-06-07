import 'dart:async';

import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class VehicleInformationViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();

  bool isLoadingProgress = false;
  Vehicle? _vehicle;

  final String _vehicleObjectId;
  VehicleInformationViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    _getVehicleInfo(context);
    subscribeToVehicleBox(context);
  }

  VehicleInformationWidgetConfiguration
      get vehicleInformationWidgetConfiguration =>
          VehicleInformationWidgetConfiguration(_vehicle);

  Stream<BoxEvent>? vehicleStream;
  StreamSubscription<BoxEvent>? subscription;
  Future<void> subscribeToVehicleBox(BuildContext context) async {
    vehicleStream = await _vehicleService.getVehicleStream();
    subscription = vehicleStream?.listen((event) {
      _getVehicleInfo(context);
    });
  }

  Future<void> _getVehicleInfo(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _vehicle = await _vehicleService.getVehicleFromHive(
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

  void openAddingVehicleScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingVehicleScreen,
      arguments: _vehicleObjectId,
    );
  }

  @override
  Future<void> dispose() async {
    await _vehicleService.dispose();
    await subscription?.cancel();
    super.dispose();
  }
}

class VehicleInformationWidgetConfiguration {
  String? imageURL;
  late String model;
  late String mileage;
  late String licensePlate;
  late String description;
  VehicleInformationWidgetConfiguration(Vehicle? vehicle) {
    final imageIdUrl = vehicle?.imageIdUrl;
    if (imageIdUrl != null && imageIdUrl.isNotEmpty) {
      imageURL = imageIdUrl.values.toList().first;
    }
    model = vehicle?.model ?? 'Данные не получены';
    final intMileage = vehicle?.mileage;
    mileage = intMileage == null ? '' : 'Пробег $intMileage км';
    licensePlate = vehicle?.licensePlate ?? '';
    description = vehicle?.description ?? '';
  }
}
