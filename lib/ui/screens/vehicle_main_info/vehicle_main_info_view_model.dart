import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:autospectechnics/domain/entities/vehicle_details.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';

class VehicleMainInfoViewModel extends ChangeNotifier {
  final String _vehicleObjectId;

  final _vehicleService = VehicleService();
  final _recommendationService = RecommendationService();
  final _breakageService = BreakageService();
  final _completedRepairService = CompletedRepairService();
  final _routineMaintenanceService = RoutineMaintenanceService();

  bool isLoadingProgress = false;
  VehicleDetails? _vehicleDetails;
  final List<Recommendation> _recommendationList = [];
  final List<Breakage> _breakageList = [];
  final List<CompletedRepair> _completedRepairList = [];
  final List<RoutineMaintenance> _routineMaintenanceList = [];

  VehicleMainInfoViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    getVehicleInfo(context);
  }

  String? get imageURL => _vehicleDetails?.imageURL;
  VehicleDataWidgetConfiguration get vehicleDataWidgetConfiguration =>
      VehicleDataWidgetConfiguration(_vehicleDetails);
  RecommendationsWidgetConfiguration get recommendationsWidgetConfiguration =>
      RecommendationsWidgetConfiguration(_recommendationList);
  BreakagesWidgetConfiguration get breakagesWidgetConfiguration =>
      BreakagesWidgetConfiguration(_breakageList);
  RepairHistoryWidgetConfiguration get repairHistoryWidgetConfiguration =>
      RepairHistoryWidgetConfiguration(_completedRepairList);
  RoutineMaintenanceWidgetConfiguration
      get routineMaintenanceWidgetConfiguration =>
          RoutineMaintenanceWidgetConfiguration(_routineMaintenanceList);

  Future<void> getVehicleInfo(BuildContext context) async {
    isLoadingProgress = true;
    notifyListeners();

    try {
      _vehicleDetails = await _vehicleService.getVehicleDetails(
          vehicleObjectId: _vehicleObjectId);

      _recommendationList.addAll(
        await _recommendationService.getVehicleRecommendations(
            vehicleObjectId: _vehicleObjectId),
      );

      _breakageList.addAll(
        await _breakageService.getVehicleBreakages(
            vehicleObjectId: _vehicleObjectId),
      );

      _completedRepairList.addAll(
        await _completedRepairService.getVehicleCompletedRepairs(
            vehicleObjectId: _vehicleObjectId),
      );

      _routineMaintenanceList.addAll(
        await _routineMaintenanceService.getVehicleRoutineMaintenanceList(
            vehicleObjectId: _vehicleObjectId),
      );
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

  void openRecommendationsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.recommendationsScreen,
      arguments: _vehicleObjectId,
    );
  }

  void openBreakagesScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.breakagesScreen,
      arguments: _vehicleObjectId,
    );
  }

  void openRepairHistoryScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.repairHistoryScreen,
      arguments: _vehicleObjectId,
    );
  }

  void openRoutineMaintenanceScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.routineMaintenanceScreen,
      arguments: _vehicleObjectId,
    );
  }
}

class VehicleDataWidgetConfiguration {
  late String model;
  late String mileage;
  late String licensePlate;
  late String description;
  VehicleDataWidgetConfiguration(VehicleDetails? vehicleDetails) {
    model = vehicleDetails?.model ?? 'Данные не получены';
    final intMileage = vehicleDetails?.mileage;
    mileage = intMileage == null ? '' : 'Пробег $intMileage км';
    licensePlate = vehicleDetails?.licensePlate ?? '';
    description = vehicleDetails?.description ?? '';
  }
}

class RecommendationsWidgetConfiguration {
  late String upperLeftText;
  late String recommendationsAmount;
  late String lowerLeftText;
  late String lastRecommendationTitle;
  RecommendationsWidgetConfiguration(List<Recommendation> recommendationList) {
    if (recommendationList.isEmpty) {
      upperLeftText = 'Нет рекомендаций';
      recommendationsAmount = '';
      lowerLeftText = '';
      lastRecommendationTitle = '';
    } else {
      upperLeftText = 'Всего рекомендаций';
      recommendationsAmount = recommendationList.length.toString();
      lowerLeftText = 'Последняя';
      lastRecommendationTitle = recommendationList.last.title;
    }
  }
}

class BreakagesWidgetConfiguration {
  late String upperLeftText;
  late String breakagesAmount;
  late String lowerLeftText;
  late String lastBreakageTitle;
  BreakagesWidgetConfiguration(List<Breakage> breakageList) {
    if (breakageList.isEmpty) {
      upperLeftText = 'Активных поломок';
      breakagesAmount = 'Нет';
      lowerLeftText = '';
      lastBreakageTitle = '';
    } else {
      upperLeftText = 'Активных поломок';
      breakagesAmount = breakageList.length.toString();
      lowerLeftText = 'Приоритетная';
      lastBreakageTitle = breakageList.first.title;
    }
  }
}

class RepairHistoryWidgetConfiguration {
  late String upperLeftText;
  late String completedRepairAmount;
  late String lowerLeftText;
  late String lastcompletedRepairTitle;
  RepairHistoryWidgetConfiguration(List<CompletedRepair> completedRepairList) {
    if (completedRepairList.isEmpty) {
      upperLeftText = 'Работы не проводились';
      completedRepairAmount = '';
      lowerLeftText = '';
      lastcompletedRepairTitle = '';
    } else {
      upperLeftText = 'Всего работ';
      completedRepairAmount = completedRepairList.length.toString();
      lowerLeftText = 'Последняя';
      lastcompletedRepairTitle = completedRepairList.first.title;
    }
  }
}

class RoutineMaintenanceWidgetConfiguration {
  late String upperLeftText;
  late String remainEngineHours;
  late String lowerLeftText;
  late String nearestRoutineMaintenance;
  RoutineMaintenanceWidgetConfiguration(
      List<RoutineMaintenance> routineMaintenanceList) {
    if (routineMaintenanceList.isEmpty) {
      upperLeftText = 'Регламенты не заданы';
      remainEngineHours = '';
      lowerLeftText = '';
      nearestRoutineMaintenance = '';
    } else {
      upperLeftText = 'Остаток ресурса';
      remainEngineHours =
          routineMaintenanceList.first.remainEngineHours.toString();
      lowerLeftText = 'Ближайшая работа';
      nearestRoutineMaintenance = routineMaintenanceList.first.title;
    }
  }
}
