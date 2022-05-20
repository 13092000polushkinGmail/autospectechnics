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

class ObjectMainInfoViewModel extends ChangeNotifier {
  final String _buildingObjectId;

  final _buildingObjectService = BuildingObjectService();
  final _vehicleBuildingObjectService = VehicleBuildingObjectService();
  final _vehicleService = VehicleService();

  bool isLoadingProgress = false;
  int _vehicleStatus = -2;
  BuildingObject? _buildingObject;
  List<ExtendedVehicle> _vehiclesList = [];

  ObjectMainInfoViewModel(
    this._buildingObjectId,
    BuildContext context,
  ) {
    getBuildingObjectInfo(context);
  }

  int get vehiclesListLength => _vehiclesList.length;
  InformationWidgetConfiguration get informationWidgetConfiguration =>
      InformationWidgetConfiguration(_buildingObject, _vehicleStatus);
  VehicleWidgetConfiguration getVehicleWidgetConfiguration(int index) =>
      VehicleWidgetConfiguration(_vehiclesList[index]);

  Future<void> getBuildingObjectInfo(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();

    try {
      _buildingObject = await _buildingObjectService.getBuildingObjectFromHive(
          buildingObjectId: _buildingObjectId);
      final vehicleBuildingObjectList = await _vehicleBuildingObjectService
          .getVehicleBuildingObjectListFromHive(_buildingObjectId);
      for (var vehicleBuildingObject in vehicleBuildingObjectList) {
        final vehicle = await _vehicleService.getVehicleFromHive(
            vehicleObjectId: vehicleBuildingObject.vehicleId);
        if (vehicle != null) {
          final vehicleStatus = Vehicle.getVehicleDangerLevel(
              vehicle, vehicleBuildingObject.requiredEngineHours);
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

  void openVehicleInfoScreen(BuildContext context, int index) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.vehicleMainInfoScreen,
      arguments: _vehiclesList[index].vehicle.objectId,
    );
  }
}

class InformationWidgetConfiguration {
  late String startDate;
  late String finishDate;
  late List<String> photosURL;
  late DaysInfo daysInfo;
  String? breakageIcon;
  late String description;
  late String buildingObjectTitle;

  InformationWidgetConfiguration(
      BuildingObject? buildingObject, int vehicleStatus) {
    startDate = DateFormatter.getFormattedDate(buildingObject?.startDate);
    finishDate = DateFormatter.getFormattedDate(buildingObject?.finishDate);
    photosURL = buildingObject?.photosURL ?? [];
    daysInfo = DateFormatter.getDaysInfo(
        buildingObject?.startDate, buildingObject?.finishDate);
    buildingObjectTitle = buildingObject?.title ?? 'Название объекта';
    if (vehicleStatus >= -1) {
      breakageIcon = BreakageDangerLevel(vehicleStatus).iconName;
    }
    description = buildingObject?.description ?? '';
  }
}

class VehicleWidgetConfiguration {
  late String? imageURL;
  late String title;
  late String breakageIcon;
  String? remainEngineHours;
  late String requiredEngineHours;
  VehicleWidgetConfiguration(ExtendedVehicle extendedVehicle) {
    imageURL = extendedVehicle.vehicle.imageURL;
    title = extendedVehicle.vehicle.model;
    breakageIcon = BreakageDangerLevel(Vehicle.getVehicleDangerLevel(
            extendedVehicle.vehicle, extendedVehicle.requiredEngineHours))
        .iconName;
    remainEngineHours =
        extendedVehicle.vehicle.hoursInfo?.remainEngineHours.toString();
    requiredEngineHours = extendedVehicle.requiredEngineHours.toString();
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
