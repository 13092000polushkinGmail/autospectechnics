import 'package:autospectechnics/resources/resources.dart';

abstract class VehicleNodeNames {
  static const engine = 'Engine';
  static const bodywork = 'Bodywork';
  static const transmission = 'Transmission';
  static const chassis = 'Chassis';
  static const technicalLiquids = 'Technical liquids';
  static const otherNodes = 'Other nodes';

  static String getNameByIndex(int index) {
    switch (index) {
      case 0:
        return engine;
      case 1:
        return bodywork;
      case 2:
        return transmission;
      case 3:
        return chassis;
      case 4:
        return technicalLiquids;
      case 5:
        return otherNodes;
      default:
        return '';
    }
  }

  static String getIconName(String vehicleNode) {
    String vehicleNodeIconName;
    if (vehicleNode == 'Engine') {
      vehicleNodeIconName = AppSvgs.engine;
    } else if (vehicleNode == 'Bodywork') {
      vehicleNodeIconName = AppSvgs.bodywork;
    } else if (vehicleNode == 'Transmission') {
      vehicleNodeIconName = AppSvgs.transmission;
    } else if (vehicleNode == 'Chassis') {
      vehicleNodeIconName = AppSvgs.chassis;
    } else if (vehicleNode == 'Technical liquids') {
      vehicleNodeIconName = AppSvgs.technicalLiquids;
    } else if (vehicleNode == 'Other nodes') {
      vehicleNodeIconName = AppSvgs.otherNodes;
    } else {
      vehicleNodeIconName = AppSvgs.significantBreakage;
    }
    return vehicleNodeIconName;
  }
}
