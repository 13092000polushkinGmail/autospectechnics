import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/top_circular_progress_indicator.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/screens/vehicle_main_info/vehicle_main_info_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleMainInfoScreen extends StatelessWidget {
  const VehicleMainInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Авто',
        hasBackButton: true,
        onDeleteButtonTap: () => model.onDeleteButtonTap(context),
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Записать моточасы и пробег'),
        onPressed: () => model.openWritingEngineHoursScreen(context),
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
    final isLoadingProgress =
        context.select((VehicleMainInfoViewModel vm) => vm.isLoadingProgress);
    final imageURL =
        context.select((VehicleMainInfoViewModel vm) => vm.imageURL);
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.8,
                  child: NetworkImageWidget(url: imageURL),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: const [
                      SizedBox(height: 152),
                      _VehicleDataWidget(),
                      SizedBox(height: 12),
                      _RoutineMaintenanceWidget(),
                      SizedBox(height: 12),
                      _RecommendationsWidget(),
                      SizedBox(height: 12),
                      _BreakagesWidget(),
                      SizedBox(height: 12),
                      _RepairHistoryWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isLoadingProgress) const TopCircularProgressIndicator(),
      ],
    );
  }
}

class _RoutineMaintenanceWidget extends StatelessWidget {
  const _RoutineMaintenanceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    final configuration = context.select((VehicleMainInfoViewModel vm) =>
        vm.routineMaintenanceWidgetConfiguration);
    return _InfoCardWidget(
      title: 'ТО',
      upperLeftText: configuration.upperLeftText,
      upperRightText: configuration.remainEngineHours,
      lowerLeftText: configuration.lowerLeftText,
      lowerRightText: configuration.nearestRoutineMaintenance,
      onTap: () => model.openRoutineMaintenanceScreen(context),
    );
  }
}

class _RepairHistoryWidget extends StatelessWidget {
  const _RepairHistoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    final configuration = context.select(
        (VehicleMainInfoViewModel vm) => vm.repairHistoryWidgetConfiguration);
    return _InfoCardWidget(
      title: 'История работ',
      upperLeftText: configuration.upperLeftText,
      upperRightText: configuration.completedRepairAmount,
      lowerLeftText: configuration.lowerLeftText,
      lowerRightText: configuration.lastcompletedRepairTitle,
      onTap: () => model.openRepairHistoryScreen(context),
    );
  }
}

class _BreakagesWidget extends StatelessWidget {
  const _BreakagesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    final configuration = context.select(
        (VehicleMainInfoViewModel vm) => vm.breakagesWidgetConfiguration);
    return _InfoCardWidget(
      title: 'Поломки',
      upperLeftText: configuration.upperLeftText,
      upperRightText: configuration.breakagesAmount,
      lowerLeftText: configuration.lowerLeftText,
      lowerRightText: configuration.lastBreakageTitle,
      onTap: () => model.openBreakagesScreen(context),
    );
  }
}

class _RecommendationsWidget extends StatelessWidget {
  const _RecommendationsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    final configuration = context.select(
        (VehicleMainInfoViewModel vm) => vm.recommendationsWidgetConfiguration);
    return _InfoCardWidget(
      title: 'Рекомендации',
      upperLeftText: configuration.upperLeftText,
      upperRightText: configuration.recommendationsAmount,
      lowerLeftText: configuration.lowerLeftText,
      lowerRightText: configuration.lastRecommendationTitle,
      onTap: () => model.openRecommendationsScreen(context),
    );
  }
}

class _VehicleDataWidget extends StatelessWidget {
  const _VehicleDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleMainInfoViewModel>();
    final configuration = context.select(
        (VehicleMainInfoViewModel vm) => vm.vehicleDataWidgetConfiguration);
    return _InfoCardWidget(
      title: 'Данные авто',
      upperLeftText: configuration.model,
      upperRightText: configuration.licensePlate,
      lowerLeftText: configuration.mileage,
      lowerRightText: configuration.description,
      onTap: () => model.openVehicleInformationScreen(context),
    );
  }
}

class _InfoCardWidget extends StatelessWidget {
  final String title;
  final String upperLeftText;
  final String upperRightText;
  final String lowerLeftText;
  final String lowerRightText;
  final void Function()? onTap;

  const _InfoCardWidget({
    Key? key,
    required this.title,
    required this.upperLeftText,
    required this.upperRightText,
    required this.lowerLeftText,
    required this.lowerRightText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.semiBold
                          .copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _SmallTextWidget(text: upperLeftText),
                        const SizedBox(width: 8),
                        if (upperRightText.isNotEmpty)
                          _SmallTextWidget(text: upperRightText),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _SmallTextWidget(text: lowerLeftText),
                        const SizedBox(width: 8),
                        _SmallTextWidget(text: lowerRightText),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.greyText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallTextWidget extends StatelessWidget {
  const _SmallTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.hint.copyWith(color: AppColors.greyText),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }
}
