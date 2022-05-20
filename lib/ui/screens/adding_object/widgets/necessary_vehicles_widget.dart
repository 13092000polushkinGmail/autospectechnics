import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NecessaryVehiclesWidget extends StatelessWidget {
  const NecessaryVehiclesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingObjectViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Необходимая техника'),
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
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stepperConfiguration =
        context.select((AddingObjectViewModel vm) => vm.stepperConfiguration);
    final vehiclesListLength =
        context.select((AddingObjectViewModel vm) => vm.vehiclesListLength);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        StepperWidget(configuration: stepperConfiguration),
        const SizedBox(height: 32),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.78, // 16 / 9
          ),
          itemCount: vehiclesListLength,
          itemBuilder: (_, index) => _VehicleWidget(index: index),
        )
      ],
    );
  }
}

class _VehicleWidget extends StatelessWidget {
  final int index;
  const _VehicleWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingObjectViewModel>();
    final configuration = context.select(
        (AddingObjectViewModel vm) => vm.getVehicleWidgetConfiguration(index));
    return GestureDetector(
      onTap: () => model.onVehicleCardTap(index),
      child: SizedBox(
          height: 96,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: configuration.borderColor,
                  width: configuration.borderWidth),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppColors.white.withOpacity(0.25),
                      BlendMode.dstATop,
                    ),
                    child: NetworkImageWidget(url: configuration.imageURL),
                  ),
                ),
                Center(
                  child: Text(
                    configuration.title,
                    style: AppTextStyles.semiBold.copyWith(
                      color: configuration.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
