import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class RepairHistoryViewModel extends ChangeNotifier {
  void openCompletedRepairScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.completedRepairScreen);
  }

  void openAddingCompletedRepairScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.addingCompletedRepairScreen);
  }
}