import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/adding_several_photos_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/several_photos_from_server_widget.dart';
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
      appBar: AppBarWidget(
        title: model.screenTitle,
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
    final model = context.watch<AddingRecommendationViewModel>();
    final selectedIndex = context.select(
        (AddingRecommendationViewModel vm) => vm.selectedVehiicleNodeIndex);
    final pickedImageList = context
        .select((AddingRecommendationViewModel vm) => vm.pickedImageList);
    final imagesFromServerIdURLs = context.select(
        (AddingRecommendationViewModel vm) => vm.imagesFromServerIdURLs);
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
      ],
    );
  }
}
