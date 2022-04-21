import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_photo_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/object_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectFormMainInfoWidget extends StatelessWidget {
  const ObjectFormMainInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingObjectViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Основная информация',
        hasBackButton: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          const ObjectStepperWidget(),
          const SizedBox(height: 32),
          const AddingPhotoWidget(width: 328, height: 192),
          const SizedBox(height: 32),
          TextFieldTemplateWidget(
            controller: model.startDateTextControler,
            hintText: 'Дата начала работы',
          ),
          const SizedBox(height: 16),
          TextFieldTemplateWidget(
            controller: model.finishDateTextControler,
            hintText: 'Дата завершения работ',
          ),
          const SizedBox(height: 16),
          TextFieldTemplateWidget(
            controller: model.descriptionTextControler,
            hintText: 'Описание работ',
          ),
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