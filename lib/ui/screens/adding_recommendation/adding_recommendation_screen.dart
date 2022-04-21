import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/vehicle_node_picker_widget.dart';
import 'package:autospectechnics/ui/screens/adding_recommendation/adding_recommendation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingRecommendationScreen extends StatelessWidget {
  const AddingRecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        //Такой заголовок не входит на экран title: 'Добавление рекомендации',
        title: 'Добавить рекомендацию',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
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
    final model = context.read<AddingRecommendationViewModel>();
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const HeaderWidget(
          text: 'Для какого узла рекомендация?',
        ),
        const SizedBox(height: 16),
        const VehicleNodePickerWidget(),
        const SizedBox(height: 24),
        TextFieldTemplateWidget(controller: model.nameTextControler, hintText: 'Название'),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Содержание',
          maxLines: 5,
        ),
      ],
    );
  }
}
