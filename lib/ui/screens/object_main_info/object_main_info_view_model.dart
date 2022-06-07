import 'dart:async';

import 'package:autospectechnics/ui/global_widgets/confirm_dialog_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:autospectechnics/domain/date_formatter.dart';
import 'package:autospectechnics/domain/entities/building_object.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/parse_database_string_names/breakage_danger_level.dart';
import 'package:autospectechnics/domain/services/building_object_service.dart';
import 'package:autospectechnics/domain/services/vehicle_bulding_object_service.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:hive/hive.dart';

class ObjectMainInfoViewModel extends ChangeNotifier {
  final String _buildingObjectId;

  final _buildingObjectService = BuildingObjectService();
  late final _vehicleBuildingObjectService =
      VehicleBuildingObjectService(_buildingObjectId);
  final _vehicleService = VehicleService();

  bool isLoadingProgress = false;
  int _vehicleStatus = -2;
  BuildingObject? _buildingObject;
  final List<ExtendedVehicle> _vehiclesList = [];

  ObjectMainInfoViewModel(
    this._buildingObjectId,
    BuildContext context,
  ) {
    getBuildingObjectInfo(context);
    subscribeToVehicleBox(context);
    subscribeToBuildingObjectBox(context);
    subscribeToVehicleBuildingObjectBox(context);
  }

  List<ExtendedVehicle> get vehiclesList => _vehiclesList;

  InformationWidgetConfiguration get informationWidgetConfiguration =>
      InformationWidgetConfiguration(_buildingObject, _vehicleStatus);

  VehicleWidgetConfiguration? getVehicleWidgetConfiguration(int index) {
    if (index < _vehiclesList.length) {
      return VehicleWidgetConfiguration(_vehiclesList[index]);
    }
  }

  Stream<BoxEvent>? vehicleStream;
  StreamSubscription<BoxEvent>? vehicleSubscription;
  Future<void> subscribeToVehicleBox(BuildContext context) async {
    vehicleStream = await _vehicleService.getVehicleStream();
    vehicleSubscription = vehicleStream?.listen((event) {
      getBuildingObjectInfo(context);
    });
  }

  Stream<BoxEvent>? buildingObjectStream;
  StreamSubscription<BoxEvent>? buildingObjectSubscription;
  Future<void> subscribeToBuildingObjectBox(BuildContext context) async {
    buildingObjectStream =
        await _buildingObjectService.getBuildingObjectStream();
    buildingObjectSubscription = buildingObjectStream?.listen((event) {
      getBuildingObjectInfo(context);
    });
  }

  Stream<BoxEvent>? vehicleBuildingObjectStream;
  StreamSubscription<BoxEvent>? vehicleBuildingObjectSubscription;
  Future<void> subscribeToVehicleBuildingObjectBox(BuildContext context) async {
    vehicleBuildingObjectStream =
        await _vehicleBuildingObjectService.getVehicleBuildingObjectStream();
    vehicleBuildingObjectSubscription =
        vehicleBuildingObjectStream?.listen((event) {
      getBuildingObjectInfo(context);
    });
  }

  Future<void> getBuildingObjectInfo(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();
    try {
      _vehiclesList.clear();
      _vehicleStatus = -2;
      _buildingObject = await _buildingObjectService.getBuildingObjectFromHive(
          buildingObjectId: _buildingObjectId);
      final vehicleBuildingObjectList = await _vehicleBuildingObjectService
          .getVehicleBuildingObjectListFromHive(_buildingObjectId);
      for (var vehicleBuildingObject in vehicleBuildingObjectList) {
        final vehicle = await _vehicleService.getVehicleFromHive(
            vehicleObjectId: vehicleBuildingObject.vehicleId);
        if (vehicle != null) {
          final vehicleStatus =
              vehicle.getVehicleStatusFromRoutineMaintenanceInfo(
                  vehicleBuildingObject.requiredEngineHours);
          if (vehicleStatus > _vehicleStatus) {
            _vehicleStatus = vehicleStatus;
          }
          _vehiclesList.add(
            ExtendedVehicle(
              vehicle: vehicle,
              requiredEngineHours: vehicleBuildingObject.requiredEngineHours,
            ),
          );
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

    isLoadingProgress = false;
    notifyListeners();
  }

  Future<void> onDeleteButtonTap(BuildContext context) async {
    final isConfirmed = await ConfirmDialogWidget.isConfirmed(context: context);
    if (!isConfirmed) return;
    try {
      await _vehicleBuildingObjectService
          .deleteVehicleBuildingObjectsOfBuildingObject(_buildingObjectId);
      await _buildingObjectService.deleteBuildingObject(_buildingObjectId);
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

  void openUpdatingBuildingObjectScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addingObjectScreen,
      arguments: _buildingObjectId,
    );
  }

  void openVehicleInfoScreen(BuildContext context, int index) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.vehicleMainInfoScreen,
      arguments: _vehiclesList[index].vehicle.objectId,
    );
  }

  @override
  Future<void> dispose() async {
    await _vehicleService.dispose();
    await _vehicleBuildingObjectService.dispose();
    await _buildingObjectService.dispose();
    vehicleSubscription?.cancel();
    buildingObjectSubscription?.cancel();
    vehicleBuildingObjectSubscription?.cancel();
    super.dispose();
  }
}

class InformationWidgetConfiguration {
  late String title;
  String? date;
  late List<String> photosURL;
  String? days;
  String? breakageIcon;
  late String description;
  late String buildingObjectTitle;

  InformationWidgetConfiguration(
      BuildingObject? buildingObject, int vehicleStatus) {
    title = buildingObject?.title ?? '';
    final startDate = DateFormatter.getFormattedDate(buildingObject?.startDate);
    final finishDate =
        DateFormatter.getFormattedDate(buildingObject?.finishDate);
    if (startDate.isNotEmpty && finishDate.isNotEmpty) {
      date = '$startDate - $finishDate';
    }
    photosURL = buildingObject?.imagesIdUrl.values.toList() ?? [];
    final daysInfo = DateFormatter.getDaysInfo(
        buildingObject?.startDate, buildingObject?.finishDate);
    if (daysInfo != null) {
      days = '${daysInfo.daysAmount} ${daysInfo.daysText.toLowerCase()}';
    }
    buildingObjectTitle = buildingObject?.title ?? 'Название объекта';
    if (vehicleStatus >= -1) {
      breakageIcon = BreakageDangerLevel(vehicleStatus).iconName;
    }
    description = buildingObject?.description ?? '';
  }
}

class VehicleWidgetConfiguration {
  String? imageURL;
  late String title;
  late String breakageIcon;
  String? engineHoursInfo;
  VehicleWidgetConfiguration(ExtendedVehicle extendedVehicle) {
    final url = extendedVehicle.vehicle.imageIdUrl.values.toList();
    if (url.isNotEmpty) {
      imageURL = url.first;
    }
    title = extendedVehicle.vehicle.model;
    breakageIcon = BreakageDangerLevel(extendedVehicle.vehicle
            .getVehicleStatusFromRoutineMaintenanceInfo(
                extendedVehicle.requiredEngineHours))
        .iconName;
    final remainEngineHours =
        extendedVehicle.vehicle.hoursInfo?.remainEngineHours;
    final requiredEngineHours = extendedVehicle.requiredEngineHours;
    if (remainEngineHours != null) {
      engineHoursInfo = '$remainEngineHours/$requiredEngineHours';
    }
  }
}

class ExtendedVehicle {
  final Vehicle vehicle;
  final int requiredEngineHours;
  ExtendedVehicle({
    required this.vehicle,
    required this.requiredEngineHours,
  });
}
