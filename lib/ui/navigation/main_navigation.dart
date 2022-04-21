import 'package:autospectechnics/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class MainNavigationRouteNames {
  static const mainTabsScreen = '/';
  static const addingVehicleScreen = '/adding_vehicle_screen';
  static const vehicleMainInfoScreen = '/vehicle_main_info_screen';
  
  static const recommendationsScreen = '/vehicle_main_info_screen/recommendations_screen';
  static const recommendationDetailsScreen = '/vehicle_main_info_screen/recommendations_screen/recommendation_details_screen';
  static const addingRecommendationScreen = '/vehicle_main_info_screen/recommendations_screen/adding_recommendation_screen';

  static const breakagesScreen = '/vehicle_main_info_screen/breakages_screen';
  static const breakageDetailsScreen = '/vehicle_main_info_screen/breakages_screen/breakage_details_screen';
  static const addingBreakageScreen = '/vehicle_main_info_screen/breakages_screen/adding_breakage_screen';

  static const historyScreen = '/vehicle_main_info_screen/history_screen';
  static const completedRepairScreen = '/vehicle_main_info_screen/history_screen/completed_repair_screen';
  static const addingCompletedRepairScreen = '/vehicle_main_info_screen/history_screen/adding_completed_repair_screen';

  static const routineMaintenanceScreen = '/vehicle_main_info_screen/routine_maintenance_screen';
  static const writingEngineHoursScreen = '/vehicle_main_info_screen/routine_maintenance_screen/writing_engine_hours_screen';

  static const objectMainInfoScreen = '/object_main_info_screen';
  static const addingObjectScreen = '/adding_object_screen';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainTabsScreen: (_) => _screenFactory.makeMainTabs(),
    MainNavigationRouteNames.addingVehicleScreen: (_) => _screenFactory.makeAddingVehicle(),
    MainNavigationRouteNames.vehicleMainInfoScreen: (_) => _screenFactory.makeVehicleMainInfo(),
    
    MainNavigationRouteNames.recommendationsScreen: (_) => _screenFactory.makeRecommendations(),
    MainNavigationRouteNames.recommendationDetailsScreen: (_) => _screenFactory.makeRecommendationDetails(),
    MainNavigationRouteNames.addingRecommendationScreen: (_) => _screenFactory.makeAddingRecommendation(),

    MainNavigationRouteNames.breakagesScreen: (_) => _screenFactory.makeBreakages(),
    MainNavigationRouteNames.breakageDetailsScreen: (_) => _screenFactory.makeBreakageDetails(),
    MainNavigationRouteNames.addingBreakageScreen: (_) => _screenFactory.makeAddingBreakage(),

    MainNavigationRouteNames.historyScreen: (_) => _screenFactory.makeHistory(),
    MainNavigationRouteNames.completedRepairScreen: (_) => _screenFactory.makeCompletedRepair(),
    MainNavigationRouteNames.addingCompletedRepairScreen: (_) => _screenFactory.makeAddingCompletedRepair(),

    MainNavigationRouteNames.routineMaintenanceScreen: (_) => _screenFactory.makeRoutineMaintenance(),
    MainNavigationRouteNames.writingEngineHoursScreen: (_) => _screenFactory.makeWritingEngineHours(),

    MainNavigationRouteNames.objectMainInfoScreen: (_) => _screenFactory.makeObjectMainInfo(),
    MainNavigationRouteNames.addingObjectScreen: (_) => _screenFactory.makeAddingObject(),
  };

  // Route<Object> onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
      //     case MainNavigationRouteNames.movieDetails:
      //       final arguments = settings.arguments;
      //       final movieId = arguments is int ? arguments : 0;
      //       return MaterialPageRoute(
      //         builder: (_) => _screenFactory.makeMovieDetails(movieId),
      //       );
      //     case MainNavigationRouteNames.movieTrailerWidget:
      //       final arguments = settings.arguments;
      //       final youtubeKey = arguments is String ? arguments : '';
      //       return MaterialPageRoute(
      //         builder: (_) => _screenFactory.makeMovieTrailer(youtubeKey),
      //       );
  //     default:
  //       const widget = Text('Navigation error!!!');
  //       return MaterialPageRoute(builder: (_) => widget);
  //   }
  // }
}
