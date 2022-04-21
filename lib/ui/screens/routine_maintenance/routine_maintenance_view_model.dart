import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class RoutineMaintenanceViewModel extends ChangeNotifier {
  void openWritingEngineHoursScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.writingEngineHoursScreen);
  }
}