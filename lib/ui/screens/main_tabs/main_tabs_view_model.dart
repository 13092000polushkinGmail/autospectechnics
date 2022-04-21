import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class MainTabsViewModel extends ChangeNotifier {
  var _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }

  void openAddingVehicleScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingVehicleScreen);
  }
  
  void openVehicleInfoScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.vehicleMainInfoScreen);
  }

  void openObjectInfoScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.objectMainInfoScreen);
  }

  void openAddingObjectScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingObjectScreen);
  }
}
