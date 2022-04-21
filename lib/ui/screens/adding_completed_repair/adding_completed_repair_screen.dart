import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_photo_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/vehicle_node_picker_widget.dart';
import 'package:autospectechnics/ui/screens/adding_completed_repair/adding_completed_repair_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingCompletedRepairScreen extends StatelessWidget {
  const AddingCompletedRepairScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        //TODO У нас есть два экрана: добавление записи в историю со страницы поломки по нажатию на кнопку "Устранено" и добавление через кнопку добавить в историю
        //Подумать как грамотно развести эти случаи потому как форма одинаковая, но первую надо предварительно заполнить данными поломки, а вторую надо заполнять вручную
        title: 'Добавить в историю',
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
    final model = context.read<AddingCompletedRepairViewModel>();
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const HeaderWidget(
          text: 'Над каким узлом провдена работа?',
        ),
        const SizedBox(height: 16),
        const VehicleNodePickerWidget(),
        const SizedBox(height: 24),
        TextFieldTemplateWidget(
            controller: model.nameTextControler, hintText: 'Название'),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Описание',
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        const AddingPhotoWidget(width: 116, height: 80),
      ],
    );
  }
}
