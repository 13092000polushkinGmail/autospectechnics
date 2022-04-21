import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CircleStepState {
  disabled,
  editing,
  indexed,
  completed,
}

class CircleStepStyle {
  final Color backgroundColor;
  final Widget child;
  final Color stepConnectorColor;

  CircleStepStyle({
    required this.backgroundColor,
    required this.child,
    required this.stepConnectorColor,
  });
}

class CircleStepConfiguration {
  final int index;
  final CircleStepState stepState;
  final void Function()? onTap;

  CircleStepConfiguration({
    required this.index,
    required this.stepState,
    required this.onTap,
  });

  CircleStepStyle get style {
    switch (stepState) {
      case CircleStepState.disabled:
        return CircleStepStyle(
          backgroundColor: AppColors.greyBorder,
          child: Text(
            '${index + 1}',
            style: AppTextStyles.hint.copyWith(color: AppColors.white),
          ),
          stepConnectorColor: AppColors.greyBorder,
        );
      case CircleStepState.editing:
        return CircleStepStyle(
          backgroundColor: AppColors.blue,
          child: const Icon(
            Icons.edit,
            size: 16,
            color: AppColors.white,
          ),
          stepConnectorColor: AppColors.blue,
        );
      case CircleStepState.indexed:
        return CircleStepStyle(
          backgroundColor: AppColors.greyText,
          child: Text(
            '${index + 1}',
            style: AppTextStyles.hint.copyWith(color: AppColors.white),
          ),
          stepConnectorColor: AppColors.greyBorder,
        );
      case CircleStepState.completed:
        return CircleStepStyle(
          backgroundColor: AppColors.blue,
          child: const Icon(
            Icons.done,
            size: 16,
            color: AppColors.white,
          ),
          stepConnectorColor: AppColors.blue,
        );
    }
  }
}

class VehicleStepperWidget extends StatelessWidget {
  const VehicleStepperWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StepCircleWidget(index: 0)),
        Expanded(child: _StepCircleWidget(index: 1)),
        Expanded(child: _StepCircleWidget(index: 2)),
        Expanded(child: _StepCircleWidget(index: 3)),
        _StepCircleWidget(index: 4),
      ],
    );
  }
}

class _StepCircleWidget extends StatelessWidget {
  final int index;
  const _StepCircleWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddingVehicleViewModel>();
    final configuration = model.getCircleStepConfiguration(index);
    return Row(
      children: [
        InkWell(
          onTap: configuration.onTap,
          child: CircleAvatar(
            backgroundColor: configuration.style.backgroundColor,
            foregroundColor: AppColors.white,
            radius: 12,
            child: configuration.style.child,
          ),
        ),
        if (index != 4)
          Expanded(
            child: Container(
              height: 1,
              color: configuration.style.stepConnectorColor,
            ),
          ),
      ],
    );
  }
}