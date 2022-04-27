import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class VehicleMainInfoViewModel extends ChangeNotifier {

  VehicleMainInfoViewModel(String vehicleObjectId) {
    print(vehicleObjectId);
  }

  void openRecommendationsScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.recommendationsScreen);
  }

  void openBreakagesScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.breakagesScreen);
  }

  void openHistoryScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.historyScreen);
  }

  void openRoutineMaintenanceScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.routineMaintenanceScreen);
  }
}