import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:autospectechnics/ui/screens/adding_object/widgets/object_stepper_widget.dart';

class NecessaryVehicleWidgetStyle {
  final Color textColor;
  final Color borderColor;
  final double borderWidth;

  NecessaryVehicleWidgetStyle({
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
  });
}

class NecessaryVehicleWidgetConfiguration {
  final String title;
  final String imageName;
  bool isActive;

  NecessaryVehicleWidgetConfiguration({
    required this.title,
    required this.imageName,
    this.isActive = false,
  });

  NecessaryVehicleWidgetStyle get style {
    if (isActive) {
      return NecessaryVehicleWidgetStyle(textColor: AppColors.blue, borderColor: AppColors.blue, borderWidth: 1.5);
    }
    else {
      return NecessaryVehicleWidgetStyle(textColor: AppColors.black, borderColor: AppColors.greyBorder, borderWidth: 1);
    }
  }
}

class AddingObjectViewModel extends ChangeNotifier {
  var _currentTabIndex = 0;
  var _maxPickedTabIndex = 0;

  final startDateTextControler = TextEditingController();
  final finishDateTextControler = TextEditingController();
  final descriptionTextControler = TextEditingController();

  //TODO Их количество будет зависеть от количества выбранной техники, подумать как сделать динамически, первая идея - List<TextEditingController>, длиной равной количеству выбранных единиц техники
  final engineHoursTextControler = TextEditingController();

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

    return CircleStepConfiguration(
        index: index, stepState: stepState, onTap: onTap);
  }

  int get currentTabIndex => _currentTabIndex;

  //TODO Временная мера, потом данные нужно будет брать с сервера
  NecessaryVehicleWidgetConfiguration get configuration => NecessaryVehicleWidgetConfiguration(imageName: AppImages.valdai, title: 'ГАЗ-3310 Валдай', isActive: false);

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
