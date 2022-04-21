import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_object/widgets/object_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NecessaryResource extends StatelessWidget {
  const NecessaryResource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingObjectViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Необходимый ресурс'),
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
          TextFieldTemplateWidget(
            controller: model.engineHoursTextControler,
            hintText: 'ГАЗ-3310 Валдай',
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        text: 'Далее',
        onPressed: () {}, //=> model.incrementCurrentTabIndex(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
