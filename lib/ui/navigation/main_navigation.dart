import 'package:autospectechnics/domain/factories/screen_factory.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/adding_vehicle_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/breakage_details_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/completed_repair_arguments_configuration.dart';
import 'package:autospectechnics/ui/navigation/arguments_configurations/recommendation_details_arguments_configuration.dart';
import 'package:flutter/material.dart';

class MainNavigationRouteNames {
  static const mainTabsScreen = '/';
  static const addingVehicleScreen = '/adding_vehicle_screen';

  static const vehicleMainInfoScreen = '/vehicle_main_info_screen';
  static const writingEngineHoursScreen =
      '/vehicle_main_info_screen/writing_engine_hours_screen';

  static const vehicleInformationScreen =
      '/vehicle_main_info_screen/vehicle_information_screen';

  static const recommendationsScreen =
      '/vehicle_main_info_screen/recommendations_screen';
  static const recommendationDetailsScreen =
      '/vehicle_main_info_screen/recommendations_screen/recommendation_details_screen';
  static const addingRecommendationScreen =
      '/vehicle_main_info_screen/recommendations_screen/adding_recommendation_screen';

  static const breakagesScreen = '/vehicle_main_info_screen/breakages_screen';
  static const breakageDetailsScreen =
      '/vehicle_main_info_screen/breakages_screen/breakage_details_screen';
  static const addingBreakageScreen =
      '/vehicle_main_info_screen/breakages_screen/adding_breakage_screen';

  static const repairHistoryScreen =
      '/vehicle_main_info_screen/repair_history_screen';
  static const completedRepairScreen =
      '/vehicle_main_info_screen/history_screen/completed_repair_screen';
  static const addingCompletedRepairScreen =
      '/vehicle_main_info_screen/history_screen/adding_completed_repair_screen';

  static const routineMaintenanceScreen =
      '/vehicle_main_info_screen/routine_maintenance_screen';

  static const objectMainInfoScreen = '/object_main_info_screen';
  static const addingObjectScreen = '/adding_object_screen';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainTabsScreen: (_) =>
        _screenFactory.makeMainTabs(),
    // MainNavigationRouteNames.addingVehicleScreen: (_) =>
    //     _screenFactory.makeAddingVehicle(),

    // MainNavigationRouteNames.recommendationsScreen: (_) =>
    //     _screenFactory.makeRecommendations(),
    // MainNavigationRouteNames.recommendationDetailsScreen: (_) =>
    //     _screenFactory.makeRecommendationDetails(),
    // MainNavigationRouteNames.addingRecommendationScreen: (_) => _screenFactory.makeAddingRecommendation(),

    // MainNavigationRouteNames.breakagesScreen: (_) =>
    //     _screenFactory.makeBreakages(),
    // MainNavigationRouteNames.breakageDetailsScreen: (_) =>
    //     _screenFactory.makeBreakageDetails(),
    // MainNavigationRouteNames.addingBreakageScreen: (_) =>
    //     _screenFactory.makeAddingBreakage(),

    // MainNavigationRouteNames.historyScreen: (_) => _screenFactory.makeHistory(),
    // MainNavigationRouteNames.completedRepairScreen: (_) =>
    //     _screenFactory.makeCompletedRepair(),
    // MainNavigationRouteNames.addingCompletedRepairScreen: (_) =>
    //     _screenFactory.makeAddingCompletedRepair(),

    // MainNavigationRouteNames.routineMaintenanceScreen: (_) => _screenFactory.makeRoutineMaintenance(),
    // MainNavigationRouteNames.writingEngineHoursScreen: (_) =>
    //     _screenFactory.makeWritingEngineHours(),

    // MainNavigationRouteNames.objectMainInfoScreen: (_) =>
    //     _screenFactory.makeObjectMainInfo(),
    // MainNavigationRouteNames.addingObjectScreen: (_) =>
    //     _screenFactory.makeAddingObject(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.vehicleMainInfoScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeVehicleMainInfo(vehicleObjectId),
        );
      case MainNavigationRouteNames.writingEngineHoursScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeWritingEngineHours(vehicleObjectId),
        );
      case MainNavigationRouteNames.routineMaintenanceScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeRoutineMaintenance(vehicleObjectId),
        );
      case MainNavigationRouteNames.addingVehicleScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        int pageNumber = 0;
        if (arguments is AddingVehicleArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          pageNumber = arguments.pageIndex;
        } else {
          vehicleObjectId = arguments is String ? arguments : '';
        }
        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeAddingVehicle(vehicleObjectId, pageNumber),
        );
      case MainNavigationRouteNames.vehicleInformationScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeVehicleInformation(vehicleObjectId),
        );
      case MainNavigationRouteNames.recommendationsScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeRecommendations(vehicleObjectId),
        );
      case MainNavigationRouteNames.recommendationDetailsScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        String recommendationObjectId = '';
        if (arguments is RecommendationDetailsArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          recommendationObjectId = arguments.recommendationObjectId;
        }
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeRecommendationDetails(
              vehicleObjectId, recommendationObjectId),
        );
      case MainNavigationRouteNames.addingRecommendationScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        String recommendationObjectId = '';
        if (arguments is RecommendationDetailsArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          recommendationObjectId = arguments.recommendationObjectId;
        } else {
          vehicleObjectId = arguments is String ? arguments : '';
        }
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeAddingRecommendation(
              vehicleObjectId, recommendationObjectId),
        );
      case MainNavigationRouteNames.breakagesScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeBreakages(vehicleObjectId),
        );
      case MainNavigationRouteNames.breakageDetailsScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        String breakageObjectId = '';
        if (arguments is BreakageDetailsArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          breakageObjectId = arguments.breakageObjectId;
        }
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeBreakageDetails(
              vehicleObjectId, breakageObjectId),
        );
      case MainNavigationRouteNames.addingBreakageScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        String breakageObjectId = '';
        if (arguments is BreakageDetailsArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          breakageObjectId = arguments.breakageObjectId;
        } else {
          vehicleObjectId = arguments is String ? arguments : '';
        }
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeAddingBreakage(
              vehicleObjectId, breakageObjectId),
        );
      case MainNavigationRouteNames.repairHistoryScreen:
        final arguments = settings.arguments;
        final vehicleObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeRepairHistory(vehicleObjectId),
        );
      case MainNavigationRouteNames.completedRepairScreen:
        final arguments = settings.arguments;
        final vehicleObjectId =
            arguments is CompletedRepairArgumentsConfiguration
                ? arguments.vehicleObjectId
                : '';
        final completedRepairObjectId =
            arguments is CompletedRepairArgumentsConfiguration
                ? arguments.completedRepairObjectId
                : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeCompletedRepair(
              vehicleObjectId, completedRepairObjectId),
        );
      case MainNavigationRouteNames.addingCompletedRepairScreen:
        final arguments = settings.arguments;
        String vehicleObjectId = '';
        String completedRepairObjectId = '';
        if (arguments is CompletedRepairArgumentsConfiguration) {
          vehicleObjectId = arguments.vehicleObjectId;
          completedRepairObjectId = arguments.completedRepairObjectId;
        } else {
          vehicleObjectId = arguments is String ? arguments : '';
        }
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeAddingCompletedRepair(
              vehicleObjectId, completedRepairObjectId),
        );
      case MainNavigationRouteNames.objectMainInfoScreen:
        final arguments = settings.arguments;
        final buildingObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeObjectMainInfo(buildingObjectId),
        );
      case MainNavigationRouteNames.addingObjectScreen:
        final arguments = settings.arguments;
        final buildingObjectId = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeAddingObject(buildingObjectId),
        );
      default:
        const widget =
            Text('Ошибка навигации, пожалуйста перезапустите приложение.');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}
