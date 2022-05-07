import 'package:autospectechnics/resources/resources.dart';

class BreakageDangerLevel {
  late String name;
  late String iconName;
  BreakageDangerLevel(int dangerLevel) {
    if (dangerLevel < 0) {
      iconName = AppSvgs.minorBreakage;
      name = 'низкий';
    } else if (dangerLevel == 0) {
      iconName = AppSvgs.significantBreakage;
      name = 'средний';
    } else {
      iconName = AppSvgs.criticalBreakage;
      name = 'критический';
    }
  }
}
