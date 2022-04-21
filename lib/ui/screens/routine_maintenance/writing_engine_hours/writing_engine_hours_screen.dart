import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/writing_engine_hours/writing_engine_hours_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WritingEngineHoursScreen extends StatelessWidget {
  const WritingEngineHoursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Запись моточасов',
        hasBackButton: true,
      ),
      body: _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        text: 'Сохранить',
        onPressed: () {},
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
        ),
        const SizedBox(height: 16),
        Text(
          'Количество новых моточасов',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.black,
          ),
        ),
        Text(
          'Подумать как сделать ввод моточасов, возможно как в ресторанах через плюс и минус добавлять и убавлять моточасы соответственно',
          style: AppTextStyles.regular16.copyWith(
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        TextFieldTemplateWidget(
          controller: model.engineHoursTextController,
          hintText: '8',
        ),
      ],
    );
  }
}
