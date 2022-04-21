import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:flutter/cupertino.dart';

class ObjectMainInfoViewModel extends ChangeNotifier {
  void openVehicleInfoScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.vehicleMainInfoScreen);
  }
}