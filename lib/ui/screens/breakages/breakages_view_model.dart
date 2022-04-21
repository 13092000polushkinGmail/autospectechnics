import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class BreakagesViewModel extends ChangeNotifier {
  void openBreakageDetailsScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.breakageDetailsScreen);
  }

  void openAddingBreakageScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingBreakageScreen);
  }
}