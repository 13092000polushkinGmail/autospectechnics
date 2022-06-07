import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';

class VehicleTypePickerWidget extends StatelessWidget {
  const VehicleTypePickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тип ТС'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => model.decrementCurrentTabIndex(),
        ),
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Далее'),
        onPressed: () => model.incrementCurrentTabIndex(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stepperConfiguration =
        context.select((AddingVehicleViewModel vm) => vm.stepperConfiguration);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        StepperWidget(configuration: stepperConfiguration),
        const SizedBox(height: 32),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1,
          ),
          itemCount: 9,
          itemBuilder: (_, index) => _VehicleTypeWidget(index: index),
        ),
      ],
    );
  }
}

class _VehicleTypeWidget extends StatelessWidget {
  final int index;

  const _VehicleTypeWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    final configuration = context.select((AddingVehicleViewModel vm) =>
        vm.getVehicleTypeWidgetConfiguration(index));
    return GestureDetector(
      onTap: () => model.setSelectedVehiicleTypeIndex(index),
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: configuration.color,
              width: configuration.borderWidth,
            ),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                configuration.vehicleCard.iconName,
                color: configuration.color,
              ),
              Text(
                configuration.vehicleCard.title,
                style: AppTextStyles.smallLabels.copyWith(
                  color: configuration.color,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
