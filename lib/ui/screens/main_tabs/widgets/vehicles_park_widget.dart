import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/top_circular_progress_indicator.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/empty_main_tabs_screen_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//TODO Может быть грузить по одной тачке, показывать ее, грузуть следующую, когда она появляется добавлять в список, это на случай первой загрузки  можно попробовать
class VehiclesParkWidget extends StatelessWidget {
  const VehiclesParkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Автопарк',
        hasBackButton: false,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Добавить авто'),
        onPressed: () => model.openAddingVehicleScreen(context),
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
    final model = context.read<MainTabsViewModel>();
    final isVehicleLoadingProgress =
        context.select((MainTabsViewModel vm) => vm.isVehicleLoadingProgress);
    final vehiclesList =
        context.select((MainTabsViewModel vm) => vm.vehiclesList);
    //TODO самодельный индикатор загрузки накладывается на RefreshIndicaotor, но его нельзя убрать, потому что рефреш индикатор не работает при открытии приложения, только после попытки обновления, может это можно настроить, но проблему надо решить
    return Stack(
      children: [
        vehiclesList.isEmpty && !isVehicleLoadingProgress
            ? const EmptyMainTabsScreenWidget()
            : RefreshIndicator(
                onRefresh: () => model.getAllInfo(context),
                displacement: 8,
                child: ListView.separated(
                  itemCount: vehiclesList.length,
                  itemBuilder: (_, index) => _VehicleWidget(index: index),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 88),
                ),
              ),
        if (isVehicleLoadingProgress) const TopCircularProgressIndicator(),
      ],
    );
  }
}

class _VehicleWidget extends StatelessWidget {
  final int index;
  const _VehicleWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    final configuration = context.select(
        (MainTabsViewModel vm) => vm.getVehicleWidgetConfiguration(index));
    return configuration != null
        ? InkWell(
            onTap: () => model.openVehicleInfoScreen(context, index),
            borderRadius: BorderRadius.circular(12),
            child: DecoratedBox(
              decoration: AppBoxDecorations.cardBoxDecoration,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 1,
                      bottom: 1,
                      top: 1,
                    ), //Отступы, чтобы было видно рамку
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 108,
                        width: 116,
                        child: NetworkImageWidget(
                            url: configuration.vehicleImageURL),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _VehicleInfoWidget(index: index),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _VehicleInfoWidget extends StatelessWidget {
  final int index;
  const _VehicleInfoWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configuration = context.select(
        (MainTabsViewModel vm) => vm.getVehicleWidgetConfiguration(index));
    final progressBarValue = configuration?.progressBarValue;
    return configuration != null
        ? Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  configuration.model,
                  style: AppTextStyles.semiBold.copyWith(
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(configuration.breakageIcon),
                        Text(
                          'Статус',
                          style: AppTextStyles.hint.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: progressBarValue == null
                          ? Text(
                              'Регламенты не заданы',
                              style: AppTextStyles.hint.copyWith(
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              children: [
                                Text(
                                  configuration.remainingEngineHours,
                                  style: AppTextStyles.regular16.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                RemainingResourceProgressBarWidget(
                                  value: progressBarValue,
                                ),
                                Text(
                                  'Ближайшая работа',
                                  style: AppTextStyles.hint.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
