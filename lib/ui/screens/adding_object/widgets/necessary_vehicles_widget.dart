import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/object_stepper_widget.dart';
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
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          const ObjectStepperWidget(),
          const SizedBox(height: 32),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.78 // 16 / 9
                ),
            itemCount: 10,
            itemBuilder: (_, __) => const _VehicleWidget(),
          )
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        text: 'Далее',
        onPressed: () => model.incrementCurrentTabIndex(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _VehicleWidget extends StatelessWidget {
  const _VehicleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO возможно нужен будет watch или select
    final model = context.read<AddingObjectViewModel>();
    final configuration = model.configuration;
    return SizedBox(
      height: 96,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              configuration.imageName,
            ),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              AppColors.white.withOpacity(0.25),
              BlendMode.dstATop,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: configuration.style.borderColor,
            width: configuration.style.borderWidth
          ),
        ),
        child: Center(
          child: Text(
            configuration.title,
            style: AppTextStyles.semiBold.copyWith(
              color: configuration.style.textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
