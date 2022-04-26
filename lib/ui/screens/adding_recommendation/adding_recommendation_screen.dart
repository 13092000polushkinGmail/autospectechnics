import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_photo_widget.dart';
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
    //TODO Отметить обязательные поля, сделать отступы по бокам и остальное как в дизайне, перестроить визуальную тезнику выбора фотографий (убирать большщой фотоаппарат после выбора фотографий, показывать фотографии побольше, открывать их по нажатию)
    final model = context.read<AddingRecommendationViewModel>();
    final isLoadingProgress = context
        .select((AddingRecommendationViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: const AppBarWidget(
        //TODO Такой заголовок не входит на экран title: 'Добавление рекомендации',
        title: 'Добавить рекомендацию',
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
    final model = context.read<AddingRecommendationViewModel>();
    final selectedIndex = context.select(
        (AddingRecommendationViewModel vm) => vm.selectedVehiicleNodeIndex);
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        const HeaderWidget(
          text: 'Для какого узла рекомендация?',
        ),
        const SizedBox(height: 16),
        VehicleNodePickerWidget(
          onVehicleNodeTapSelectIndex: model.setSelectedVehiicleNodeIndex,
          selectedIndex: selectedIndex,
        ),
        const SizedBox(height: 24),
        TextFieldTemplateWidget(
            controller: model.titleTextControler, hintText: 'Название'),
        const SizedBox(height: 16),
        TextFieldTemplateWidget(
          controller: model.descriptionTextControler,
          hintText: 'Содержание',
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        AddingPhotoWidget(
          width: 120,
          height: 120,
          onTap: () => model.pickImage(context: context),
        ),
        const SizedBox(height: 16),
        const _PhotosWidget(),
      ],
    );
  }
}

class _PhotosWidget extends StatelessWidget {
  const _PhotosWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddingRecommendationViewModel>();
    final imageList = model.imageList;
    return imageList.isEmpty
        ? const SizedBox.shrink()
        : SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imageList.length,
              itemBuilder: (_, index) => imageList[index],
              separatorBuilder: (_, __) => const SizedBox(width: 8),
            ),
          );
  }
}
