import 'dart:async';

import 'package:autospectechnics/domain/entities/breakage.dart';
import 'package:autospectechnics/domain/entities/completed_repair.dart';
import 'package:autospectechnics/domain/entities/recommendation.dart';
import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/domain/entities/vehicle.dart';
import 'package:autospectechnics/domain/exceptions/api_client_exception.dart';
import 'package:autospectechnics/domain/services/breakage_service.dart';
import 'package:autospectechnics/domain/services/completed_repair_service.dart';
import 'package:autospectechnics/domain/services/recommendation_service.dart';
import 'package:autospectechnics/domain/services/routine_maintenance_service.dart';
import 'package:autospectechnics/ui/global_widgets/confirm_dialog_widget.dart';
import 'package:autospectechnics/ui/global_widgets/error_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:autospectechnics/domain/services/vehicle_service.dart';
import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:hive/hive.dart';

class VehicleMainInfoViewModel extends ChangeNotifier {
  final _vehicleService = VehicleService();
  late final _routineMaintenanceService =
      RoutineMaintenanceService(_vehicleObjectId);
  late final _breakageService = BreakageService(_vehicleObjectId);
  late final _recommendationService = RecommendationService(_vehicleObjectId);
  late final _completedRepairService = CompletedRepairService(_vehicleObjectId);

  bool isLoadingProgress = false;
  Vehicle? _vehicle;
  final List<Recommendation> _recommendationList = [];
  final List<Breakage> _breakageList = [];
  final List<CompletedRepair> _completedRepairList = [];
  final List<RoutineMaintenance> _routineMaintenanceList = [];

  final String _vehicleObjectId;
  VehicleMainInfoViewModel(
    this._vehicleObjectId,
    BuildContext context,
  ) {
    getVehicleInfo(context);
    subscribeToBoxes(context);
  }
  Stream<BoxEvent>? routineMaintenanceStream;
  StreamSubscription<BoxEvent>? routineMaintenanceSubscription;
  Stream<BoxEvent>? breakageStream;
  StreamSubscription<BoxEvent>? breakageSubscription;
  Stream<BoxEvent>? recommendationStream;
  StreamSubscription<BoxEvent>? recommendationSubscription;
  Stream<BoxEvent>? completedRepairStream;
  StreamSubscription<BoxEvent>? completedRepairSubscription;
  Stream<BoxEvent>? vehicleStream;
  StreamSubscription<BoxEvent>? vehicleSubscription;

  String get vehicleName => _vehicle?.model ?? '????????';

  Future<void> subscribeToBoxes(BuildContext context) async {
    vehicleStream = await _vehicleService.getVehicleStream();
    vehicleSubscription = vehicleStream?.listen((event) {
      getVehicleMainInfo(context);
    });

    routineMaintenanceStream =
        await _routineMaintenanceService.getRoutineMaintenanceStream();
    routineMaintenanceSubscription = routineMaintenanceStream?.listen((event) {
      getRoutineMaintenances(context);
    });

    breakageStream = await _breakageService.getBreakageStream();
    breakageSubscription = breakageStream?.listen((event) {
      getBreakages(context);
    });

    recommendationStream =
        await _recommendationService.getRecommendationStream();
    recommendationSubscription = recommendationStream?.listen((event) {
      getRecommendations(context);
    });

    completedRepairStream =
        await _completedRepairService.getCompletedRepairStream();
    completedRepairSubscription = completedRepairStream?.listen((event) {
      getCompletedRepairs(context);
    });
  }

  Future<void> getVehicleMainInfo(BuildContext context) async {
    try {
      _vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      notifyListeners();
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

  Future<void> getRoutineMaintenances(BuildContext context) async {
    try {
      _routineMaintenanceList.clear();
      _routineMaintenanceList.addAll(await _routineMaintenanceService
          .getVehicleRoutineMaintenancesFromHive());
      notifyListeners();
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

  Future<void> getBreakages(BuildContext context) async {
    try {
      _breakageList.clear();
      _breakageList
          .addAll(await _breakageService.getActiveVehicleBreakagesFromHive());
      notifyListeners();
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

  Future<void> getRecommendations(BuildContext context) async {
    try {
      _recommendationList.clear();
      _recommendationList.addAll(
          await _recommendationService.getVehicleRecommendationsFromHive());
      notifyListeners();
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

  Future<void> getCompletedRepairs(BuildContext context) async {
    try {
      _completedRepairList.clear();
      _completedRepairList.addAll(
          await _completedRepairService.getVehicleCompletedRepairsFromHive());
      notifyListeners();
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

  String? get imageURL {
    final imageIdUrl = _vehicle?.imageIdUrl;
    if (imageIdUrl != null && imageIdUrl.isNotEmpty) {
      return imageIdUrl.values.toList().first;
    }
  }

  VehicleDataWidgetConfiguration get vehicleDataWidgetConfiguration =>
      VehicleDataWidgetConfiguration(_vehicle);
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
    final stopwatch = Stopwatch()..start();
    isLoadingProgress = true;
    notifyListeners();

    try {
      _vehicle = await _vehicleService.getVehicleFromHive(
          vehicleObjectId: _vehicleObjectId);
      notifyListeners();

      _routineMaintenanceList.addAll(await _routineMaintenanceService
          .getVehicleRoutineMaintenancesFromHive());
      notifyListeners();

      _breakageList
          .addAll(await _breakageService.getActiveVehicleBreakagesFromHive());
      notifyListeners();

      _recommendationList.addAll(
          await _recommendationService.getVehicleRecommendationsFromHive());
      notifyListeners();

      _completedRepairList.addAll(
          await _completedRepairService.getVehicleCompletedRepairsFromHive());
      notifyListeners();

      //TODO ???????????????? ?????? ???? ???? ??????????????????, ?????????????? ?????????? ??????????????????????
      //TODO ???????????????? ?????????????? ?????????? vehicle (?????? ???????????????? "???????????? ????????"), ?????????? ???????????????????????????????? ???????? ?? ????????????????, ?????????? ???? ???????????????? ?????????? ???????????????? ???????? ??????????

      //TODO ?????? ?????????????????????? ?????? ???????????????? ???????????????? ????????????
      // final routineMaintenancesFromServer = await _routineMaintenanceService
      //     .downloadVehicleRoutineMaintenanceList();
      // _routineMaintenanceList.clear();
      // _routineMaintenanceList.addAll(routineMaintenancesFromServer);
      // notifyListeners();

      final recommendationsFromServer =
          await _recommendationService.downloadVehicleRecommendations();
      _recommendationList.clear();
      _recommendationList.addAll(recommendationsFromServer);
      notifyListeners();

      final breakagesFromServer =
          await _breakageService.downloadAllVehicleBreakagesAndShowActive();
      _breakageList.clear();
      _breakageList.addAll(breakagesFromServer);
      notifyListeners();

      final completedRepairsFromServer =
          await _completedRepairService.downloadVehicleCompletedRepairs();
      _completedRepairList.clear();
      _completedRepairList.addAll(completedRepairsFromServer);
      notifyListeners();
      stopwatch.stop();
      print('???????????????? ???????? ?? ???? ${stopwatch.elapsed}');
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
      await _vehicleService.deleteVehicle(_vehicleObjectId);
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

  void openVehicleInformationScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.vehicleInformationScreen,
      arguments: _vehicleObjectId,
    );
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

  void openWritingEngineHoursScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.writingEngineHoursScreen,
      arguments: _vehicleObjectId,
    );
  }

  @override
  Future<void> dispose() async {
    await _breakageService.dispose();
    await _recommendationService.dispose();
    await _completedRepairService.dispose();
    await _routineMaintenanceService.dispose();
    await _vehicleService.dispose();
    breakageSubscription?.cancel();
    recommendationSubscription?.cancel();
    completedRepairSubscription?.cancel();
    routineMaintenanceSubscription?.cancel();
    vehicleSubscription?.cancel();
    super.dispose();
  }
}

class VehicleDataWidgetConfiguration {
  late String model;
  late String mileage;
  late String licensePlate;
  late String description;
  VehicleDataWidgetConfiguration(Vehicle? vehicle) {
    model = vehicle?.model ?? '???????????? ???? ????????????????';
    final intMileage = vehicle?.mileage;
    mileage = intMileage == null ? '' : '???????????? $intMileage ????';
    licensePlate = vehicle?.licensePlate ?? '';
    description = vehicle?.description ?? '';
  }
}

class RecommendationsWidgetConfiguration {
  late String upperLeftText;
  late String recommendationsAmount;
  late String lowerLeftText;
  late String lastRecommendationTitle;
  RecommendationsWidgetConfiguration(List<Recommendation> recommendationList) {
    if (recommendationList.isEmpty) {
      upperLeftText = '?????? ????????????????????????';
      recommendationsAmount = '';
      lowerLeftText = '';
      lastRecommendationTitle = '';
    } else {
      upperLeftText = '?????????? ????????????????????????';
      recommendationsAmount = recommendationList.length.toString();
      lowerLeftText = '??????????????????????';
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
      upperLeftText = '???????????????? ??????????????';
      breakagesAmount = '??????';
      lowerLeftText = '';
      lastBreakageTitle = '';
    } else {
      upperLeftText = '???????????????? ??????????????';
      breakagesAmount = breakageList.length.toString();
      lowerLeftText = '????????????????????????';
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
      upperLeftText = '???????????? ???? ??????????????????????';
      completedRepairAmount = '';
      lowerLeftText = '';
      lastcompletedRepairTitle = '';
    } else {
      upperLeftText = '?????????? ??????????';
      completedRepairAmount = completedRepairList.length.toString();
      lowerLeftText = '??????????????????';
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
      upperLeftText = '???????????????????? ???? ????????????';
      remainEngineHours = '';
      lowerLeftText = '';
      nearestRoutineMaintenance = '';
    } else {
      upperLeftText = '?????????????? ??????????????';
      remainEngineHours =
          routineMaintenanceList.first.remainEngineHours.toString();
      lowerLeftText = '?????????????????? ????????????';
      nearestRoutineMaintenance = routineMaintenanceList.first.title;
    }
  }
}
