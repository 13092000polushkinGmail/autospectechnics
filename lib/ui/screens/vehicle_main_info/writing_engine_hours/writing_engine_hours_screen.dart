import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/writing_engine_hours/writing_engine_hours_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class WritingEngineHoursScreen extends StatelessWidget {
  const WritingEngineHoursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<WritingEngineHoursViewModel>();
    final isLoadingProgress = context
        .select((WritingEngineHoursViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Запись моточасов',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: isLoadingProgress
            ? const CircularProgressIndicator()
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
    final model = context.read<WritingEngineHoursViewModel>();
    final engineHoursValue =
        context.select((WritingEngineHoursViewModel vm) => vm.engineHoursValue);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        Text(
          'Текущий пробег',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFieldTemplateWidget(
          controller: model.mileageTextController,
          hintText: '59 000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Text(
          'Количество новых моточасов',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(
              minValue: 0,
              maxValue: 100,
              value: engineHoursValue,
              step: 1,
              onChanged: (value) => model.setEngineHoursValue(value),
              textStyle:
                  AppTextStyles.timeBig.copyWith(color: AppColors.greyText),
              selectedTextStyle:
                  AppTextStyles.timeBig.copyWith(color: AppColors.blue),
              itemWidth: 72,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.blue,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: AppColors.blue,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'м.ч.',
              style: AppTextStyles.semiBold.copyWith(color: AppColors.blue),
            ),
          ],
        )
      ],
    );
  }
}
