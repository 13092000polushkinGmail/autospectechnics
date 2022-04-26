import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/image_widget.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (_, __) => const _VehicleWidget(),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      ),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Добавить авто'),
        onPressed: () => model.openAddingVehicleScreen(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _VehicleWidget extends StatelessWidget {
  const _VehicleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    return InkWell(
      onTap: () => model.openVehicleInfoScreen(context),
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(
                  left: 1, bottom: 1, top: 1), //Отступы, чтобы было видно рамку
              child: ImageWidget(imageName: AppImages.valdai),
            ),
            SizedBox(width: 16),
            Expanded(child: _VehicleInfoWidget()),
          ],
        ),
      ),
    );
  }
}

class _VehicleInfoWidget extends StatelessWidget {
  const _VehicleInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ГАЗ-3310 Валдай',
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
                  SvgPicture.asset(AppSvgs.minorBreakage),
                  Text(
                    'Поломки',
                    style: AppTextStyles.hint.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '25 м.ч.',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const RemainingResourceProgressBarWidget(
                      value: 0.5,
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
