import 'package:flutter/material.dart';

import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';

class StepperWidget extends StatelessWidget {
  final StepperWidgetConfiguration configuration;
  const StepperWidget({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: configuration.getCircleSteps(),
    );
  }
}

class _StepCircleWidget extends StatelessWidget {
  final CircleStepConfiguration stepConfiguration;
  const _StepCircleWidget({
    Key? key,
    required this.stepConfiguration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: stepConfiguration.onTap,
          child: CircleAvatar(
            backgroundColor: stepConfiguration.backgroundColor,
            foregroundColor: AppColors.white,
            radius: 12,
            child: stepConfiguration.child,
          ),
        ),
        if (stepConfiguration.hasConnector)
          Expanded(
            child: Container(
              height: 1,
              color: stepConfiguration.stepConnectorColor,
            ),
          ),
      ],
    );
  }
}

class StepperWidgetConfiguration {
  final int stepAmount;
  final int currentTabIndex;
  final int maxPickedTabIndex;
  final void Function(int index) setCurrentTabIndex;
  StepperWidgetConfiguration({
    required this.stepAmount,
    required this.currentTabIndex,
    required this.maxPickedTabIndex,
    required this.setCurrentTabIndex,
  });

  List<Widget> getCircleSteps() {
    final List<Widget> circleStepList = [];
    for (var i = 0; i < stepAmount - 1; i++) {
      final circleStep = Expanded(
        child: _StepCircleWidget(
          stepConfiguration: _getCircleStepConfiguration(i),
        ),
      );
      circleStepList.add(circleStep);
    }
    circleStepList.add(
      _StepCircleWidget(
        stepConfiguration: _getCircleStepConfiguration(stepAmount - 1),
      ),
    );
    return circleStepList;
  }

  CircleStepConfiguration _getCircleStepConfiguration(int index) {
    return CircleStepConfiguration(
      hasConnector: index < stepAmount - 1,
      index: index,
      currentTabIndex: currentTabIndex,
      maxPickedTabIndex: maxPickedTabIndex,
      onTap: () => setCurrentTabIndex(index),
    );
  }
}

enum CircleStepState {
  disabled,
  editing,
  indexed,
  completed,
}

class CircleStepConfiguration {
  final bool hasConnector;
  late Color backgroundColor;
  late Widget child;
  late Color stepConnectorColor;
  void Function()? onTap;

  CircleStepConfiguration({
    required this.hasConnector,
    required int index,
    required int currentTabIndex,
    required int maxPickedTabIndex,
    required this.onTap,
  }) {
    CircleStepState stepState;

    if (index == currentTabIndex) {
      stepState = CircleStepState.editing;
    } else if (index < currentTabIndex) {
      stepState = CircleStepState.completed;
    } else if (index < maxPickedTabIndex) {
      //&& index > _currentTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется, в нижних аналогично
      stepState = CircleStepState.completed;
    } else if (index == maxPickedTabIndex) {
      stepState = CircleStepState.indexed;
    } else {
      stepState = CircleStepState
          .disabled; //index > _maxPickedTabIndex опустил, потому что исходя из верхних условий это условие уже точно выполняется
    }

    switch (stepState) {
      case CircleStepState.disabled:
        backgroundColor = AppColors.greyBorder;
        child = Text(
          '${index + 1}',
          style: AppTextStyles.hint.copyWith(color: AppColors.white),
        );
        stepConnectorColor = AppColors.greyBorder;
        onTap = null;
        break;
      case CircleStepState.editing:
        backgroundColor = AppColors.blue;
        child = const Icon(
          Icons.edit,
          size: 16,
          color: AppColors.white,
        );
        stepConnectorColor = AppColors.blue;
        break;
      case CircleStepState.indexed:
        backgroundColor = AppColors.greyText;
        child = Text(
          '${index + 1}',
          style: AppTextStyles.hint.copyWith(color: AppColors.white),
        );
        stepConnectorColor = AppColors.greyBorder;
        break;
      case CircleStepState.completed:
        backgroundColor = AppColors.blue;
        child = const Icon(
          Icons.done,
          size: 16,
          color: AppColors.white,
        );
        stepConnectorColor = AppColors.blue;
    }
  }
}
