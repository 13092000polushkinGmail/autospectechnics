import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_several_photos_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/vehicle_node_picker_widget.dart';
import 'package:autospectechnics/ui/screens/adding_breakage/adding_breakage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddingBreakageScreen extends StatelessWidget {
  const AddingBreakageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingBreakageViewModel>();
    final isLoadingProgress =
        context.select((AddingBreakageViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Добавить поломку',
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
    final model = context.read<AddingBreakageViewModel>();
    final selectedVehiicleNodeIndex = context
        .select((AddingBreakageViewModel vm) => vm.selectedVehiicleNodeIndex);
    final imageList =
        context.select((AddingBreakageViewModel vm) => vm.imageList);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const HeaderWidget(
          text: 'В каком узле поломка?',
        ),
        const SizedBox(height: 16),
        VehicleNodePickerWidget(
          onVehicleNodeTapSelectIndex: model.setSelectedVehiicleNodeIndex,
          selectedIndex: selectedVehiicleNodeIndex,
        ),
        const SizedBox(height: 24),
        const HeaderWidget(text: 'Выберите уровень критичности'),
        const SizedBox(height: 16),
        const _BreakageDangerLevelWidget(),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.titleTextControler,
          hintText: 'Название',
        ),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Описание',
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        AddingSeveralPhotosWidget(
          imageList: imageList,
          onAddingTap: () => model.pickImage(context: context),
        ),
      ],
    );
  }
}

class _BreakageDangerLevelWidget extends StatelessWidget {
  const _BreakageDangerLevelWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StepCircleWidget(index: 0),
        Expanded(child: _StepCircleWidget(index: 1)),
        Expanded(child: _StepCircleWidget(index: 2)),
      ],
    );
  }
}

class _StepCircleWidget extends StatelessWidget {
  final int index;
  const _StepCircleWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configuration = context.select(
        (AddingBreakageViewModel vm) => vm.getCircleStepConfiguration(index));
    return Row(
      children: [
        if (index != 0)
          Expanded(
            child: Container(
              height: 1,
              color: configuration.stepConnectorColor,
            ),
          ),
        InkWell(
          onTap: configuration.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: configuration.stepConnectorColor),
            ),
            child: SizedBox(
              width: 24,
              height: 24,
              child: configuration.dangerLevelIconName.isEmpty
                  ? const SizedBox.shrink()
                  : SvgPicture.asset(configuration.dangerLevelIconName),
            ),
          ),
          customBorder: const CircleBorder(),
        ),
      ],
    );
  }
}
