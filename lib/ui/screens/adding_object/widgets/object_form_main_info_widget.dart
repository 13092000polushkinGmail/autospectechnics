import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_several_photos_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/several_photos_from_server_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/screens/adding_object/adding_object_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
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
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Далее'),
        onPressed: () => model.incrementCurrentTabIndex(),
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
    final model = context.read<AddingObjectViewModel>();
    final stepperConfiguration =
        context.select((AddingObjectViewModel vm) => vm.stepperConfiguration);
    final pickedImageList =
        context.select((AddingObjectViewModel vm) => vm.pickedImageList);
    final imagesFromServerIdURLs =
        context.select((AddingObjectViewModel vm) => vm.imagesFromServerIdURLs);
    final startDate =
        context.select((AddingObjectViewModel vm) => vm.startDate);
    final finishDate =
        context.select((AddingObjectViewModel vm) => vm.finishDate);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        StepperWidget(configuration: stepperConfiguration),
        const SizedBox(height: 32),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              AddingSeveralPhotosWidget(
                imageList: pickedImageList,
                onAddingTap: () => model.pickImage(context: context),
                onDeletePhotoTap: model.deleteImageFile,
              ),
              const SizedBox(width: 8),
              SeveralPhotosFromServerWidget(
                imageIdURLs: imagesFromServerIdURLs,
                onDeletePhotoTap: model.deleteImageFromServer,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextFieldTemplateWidget(
            controller: model.titleTextController, hintText: 'Название'),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => model.selectDate(context, true),
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
                  startDate == ''
                      ? Text(
                          'Дата начала работ',
                          style: AppTextStyles.regular16
                              .copyWith(color: AppColors.greyText),
                        )
                      : Text(
                          startDate,
                          style: AppTextStyles.regular16
                              .copyWith(color: AppColors.black),
                        ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => model.selectDate(context, false),
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
                  finishDate == ''
                      ? Text(
                          'Дата окончания работ',
                          style: AppTextStyles.regular16
                              .copyWith(color: AppColors.greyText),
                        )
                      : Text(
                          finishDate,
                          style: AppTextStyles.regular16
                              .copyWith(color: AppColors.black),
                        ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Описание работ',
          maxLines: 5,
        ),
      ],
    );
  }
}
