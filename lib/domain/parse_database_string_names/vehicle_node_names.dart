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
}
