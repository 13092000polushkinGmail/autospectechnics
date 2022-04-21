import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_photo_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleFormMainInfoWidget extends StatelessWidget {
  const VehicleFormMainInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Основная информация',
        hasBackButton: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          const VehicleStepperWidget(),
          const SizedBox(height: 32),
          const AddingPhotoWidget(width: 328, height: 192),
          const SizedBox(height: 32),
          TextFieldTemplateWidget(
            controller: model.modelTextControler,
            hintText: 'Марка и модель',
          ),
          const SizedBox(height: 16),
          TextFieldTemplateWidget(
            controller: model.yearTextControler,
            hintText: 'Год выпуска',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFieldTemplateWidget(
            controller: model.mileageTextControler,
            hintText: 'Пробег',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFieldTemplateWidget(
            controller: model.informationTextControler,
            hintText: 'Дополнительная информация',
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