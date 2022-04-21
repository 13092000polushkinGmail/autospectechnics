import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_stepper_widget.dart';
import 'package:flutter/material.dart';

class AddingVehicleViewModel extends ChangeNotifier {
  var _currentTabIndex = 0;
  var _maxPickedTabIndex = 0;

  final modelTextControler = TextEditingController();
  final yearTextControler = TextEditingController();
  final mileageTextControler = TextEditingController();
  final informationTextControler = TextEditingController();

  CircleStepConfiguration getCircleStepConfiguration(int index) {
    CircleStepState stepState;
    void Function()? onTap;

    if (index == _currentTabIndex) {
      stepState = CircleStepState.editing;
    } else if (index < _currentTabIndex) {
      stepState = CircleStepState.completed;
    } else if (index < _maxPickedTabIndex) {
      //&& index > _currentTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется, в нижних аналогично
      stepState = CircleStepState.completed;
    } else if (index == _maxPickedTabIndex) {
      stepState = CircleStepState.indexed;
    } else {
      stepState = CircleStepState
          .disabled; //index > _maxPickedTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется
    }

    if (stepState == CircleStepState.disabled) {
      onTap = null;
    } else {
      onTap = () => setCurrentTabIndex(index);
    }

    return CircleStepConfiguration(index: index, stepState: stepState, onTap: onTap);
  }

  int get currentTabIndex => _currentTabIndex;

  void incrementCurrentTabIndex() {
    _currentTabIndex += 1;
    if (_currentTabIndex > _maxPickedTabIndex) {
      _maxPickedTabIndex = _currentTabIndex;
    }
    notifyListeners();
  }

  void decrementCurrentTabIndex() {
    _currentTabIndex -= 1;
    notifyListeners();
  }

  void setCurrentTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }
}
