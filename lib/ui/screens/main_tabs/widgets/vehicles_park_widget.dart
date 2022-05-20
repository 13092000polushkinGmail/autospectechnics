import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/top_circular_progress_indicator.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//TODO Может быть грузить по одной тачке, показывать ее, грузуть следующую, когда она появляется добавлять в список
//TODO Попробовать кэшировать данные и в тайне от пользователя сверять с базой данных при входе, если будут различия, обновлять страницу
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
    final vehiclesList = context
        .select((MainTabsViewModel vm) => vm.vehiclesWidgetConfigurationList);
    //TODO самодельный индикатор загрузки накладывается на RefreshIndicaotor, но его нельзя убрать, потому что рефреш индикатор не работает при открытии приложения, только после попытки обновления, может это можно настроить, но проблему надо решить
    return Stack(
      children: [
        vehiclesList.isEmpty
            //TODO Временная мера, в идеале сообщать, что пошло не так и в зависимости от этого возвращать подходящее предложение: обновить страницу (в случае с ошибкой), добавить автомобиль в случае если автопарк пуст и тд
            ? Center(
                child: TextButton(
                  child: const Text('Обновить страницу'),
                  onPressed: () => model.downloadVehicles(context),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => model.getData(context),
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
    final vehicleWidgetConfiguration = context.select(
        (MainTabsViewModel vm) => vm.vehiclesWidgetConfigurationList[index]);
    return InkWell(
      //TODO Как-то передавать индекс в функцию
      onTap: () => model.openVehicleInfoScreen(context, index),
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 1, bottom: 1, top: 1), //Отступы, чтобы было видно рамку
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 108,
                  width: 116,
                  child: NetworkImageWidget(
                      url: vehicleWidgetConfiguration.vehicleImageURL),
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
    );
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
    final vehicleWidgetConfiguration = context.select(
        (MainTabsViewModel vm) => vm.vehiclesWidgetConfigurationList[index]);
    final progressBarValue = vehicleWidgetConfiguration.progressBarValue;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            vehicleWidgetConfiguration.model,
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
                  SvgPicture.asset(vehicleWidgetConfiguration.breakageIcon),
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
                            '${vehicleWidgetConfiguration.remainingEngineHours} м.ч.',
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
    );
  }
}
