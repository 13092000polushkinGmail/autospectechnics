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
      body: _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Сохранить'),
        onPressed: () => model.saveToDatabase(context),
      ),
      //TODO Временно заменил эту кнопку, чтобы проверить, как сохраняется транспортное средство
      // floatingActionButton: FloatingButtonWidget(
      //   child: const Text('Далее'),
      //   onPressed: () => model.incrementCurrentTabIndex(),
      // ),
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
    final model = context.read<AddingVehicleViewModel>();
    return ListView(
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const VehicleStepperWidget(),
        const SizedBox(height: 32),
        const _PhotoWidget(),
        const SizedBox(height: 32),
        TextFieldTemplateWidget(
          controller: model.modelTextControler,
          hintText: 'Марка и модель',
        ),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.mileageTextControler,
          hintText: 'Пробег',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.licensePlateTextControler,
          hintText: 'Гос. номер',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Дополнительная информация',
        ),
      ],
    );
  }
}

class _PhotoWidget extends StatelessWidget {
  const _PhotoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddingVehicleViewModel>();
    final image = model.image;
    return image == null
        ? AddingPhotoWidget(
            width: 328,
            height: 192,
            onTap: () => model.pickImage(context: context),
          )
        : SizedBox(
            height: 192,
            child: image,
          );
  }
}
