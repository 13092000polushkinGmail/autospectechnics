import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NecessaryResource extends StatelessWidget {
  const NecessaryResource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingObjectViewModel>();
    final isLoadingProgress =
        context.select((AddingObjectViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Необходимый ресурс'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => model.decrementCurrentTabIndex(),
        ),
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: isLoadingProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Text('Сохранить'),
        onPressed: () => model.saveToDatabase(context),
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
    final requiredEngineHoursWidgetConfigurationList = context.select(
        (AddingObjectViewModel vm) =>
            vm.requiredEngineHoursWidgetConfigurationList);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        StepperWidget(configuration: stepperConfiguration),
        const SizedBox(height: 32),
        requiredEngineHoursWidgetConfigurationList.isEmpty
            ? Center(
                child: Text(
                  'Транспортные средства не выбраны',
                  style:
                      AppTextStyles.regular16.copyWith(color: AppColors.black),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requiredEngineHoursWidgetConfigurationList.length,
                itemBuilder: (_, index) => TextFieldTemplateWidget(
                  controller: requiredEngineHoursWidgetConfigurationList[index]
                      .controller,
                  hintText:
                      requiredEngineHoursWidgetConfigurationList[index].title,
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              ),
      ],
    );
  }
}
