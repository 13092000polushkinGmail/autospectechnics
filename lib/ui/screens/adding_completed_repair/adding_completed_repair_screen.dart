import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_several_photos_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/vehicle_node_picker_widget.dart';
import 'package:autospectechnics/ui/screens/adding_completed_repair/adding_completed_repair_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingCompletedRepairScreen extends StatelessWidget {
  const AddingCompletedRepairScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingCompletedRepairViewModel>();
    final isLoadingProgress = context
        .select((AddingCompletedRepairViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Добавить в историю',
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
    final model = context.read<AddingCompletedRepairViewModel>();
    final selectedIndex = context.select(
        (AddingCompletedRepairViewModel vm) => vm.selectedVehiicleNodeIndex);
    final selectedDate =
        context.select((AddingCompletedRepairViewModel vm) => vm.selectedDate);
    final imageList =
        context.select((AddingCompletedRepairViewModel vm) => vm.imageList);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const HeaderWidget(
          text: 'Над каким узлом провдена работа?',
        ),
        const SizedBox(height: 16),
        VehicleNodePickerWidget(
          onVehicleNodeTapSelectIndex: model.setSelectedVehiicleNodeIndex,
          selectedIndex: selectedIndex,
        ),
        const SizedBox(height: 24),
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
        GestureDetector(
          onTap: () => model.selectDate(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.greyBorder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  Text(
                    selectedDate,
                    style: AppTextStyles.regular16
                        .copyWith(color: AppColors.black),
                  )
                ],
              ),
            ),
          ),
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
