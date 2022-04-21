import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
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
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Авто',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        text: 'Редактировать',
        onPressed: () {},
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
    final model = context.read<VehicleMainInfoViewModel>();
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Stack(
          children: [
            const AspectRatio(
              aspectRatio: 1.8,
              child: Image(
                image: AssetImage(AppImages.valdai),
                alignment: Alignment.topCenter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 152),
                  const _InfoCardWidget(
                    title: 'Данные авто',
                    upperLeftText: 'ГАЗ-3310 Валдай',
                    upperRightText: '2010 4.75(155 л.с.)',
                    lowerLeftText: 'Пробег 59 000',
                    lowerRightText: '2WD MT',
                  ),
                  const SizedBox(height: 12),
                  _InfoCardWidget(
                    title: 'ТО',
                    upperLeftText: 'Остаток ресурса',
                    upperRightText: '50 м.ч.',
                    lowerLeftText: 'Ближайшая работа',
                    lowerRightText: 'Масло КПП',
                    onTap: () => model.openRoutineMaintenanceScreen(context),
                  ),
                  const SizedBox(height: 12),
                  _InfoCardWidget(
                    title: 'Рекомендации',
                    upperLeftText: 'Всего рекомендаций',
                    upperRightText: '1',
                    lowerLeftText: 'Последняя',
                    lowerRightText: 'Заменить АКБ',
                    onTap: () => model.openRecommendationsScreen(context),
                  ),
                  const SizedBox(height: 12),
                  _InfoCardWidget(
                    title: 'Поломки',
                    upperLeftText: 'Активных поломок',
                    upperRightText: 'Нет',
                    lowerLeftText: 'Последняя',
                    lowerRightText: 'Ось КПП',
                    onTap: () => model.openBreakagesScreen(context),
                  ),
                  const SizedBox(height: 12),
                  _InfoCardWidget(
                    title: 'История работ',
                    upperLeftText: 'Всего работ',
                    upperRightText: '15',
                    lowerLeftText: 'Последняя',
                    lowerRightText: 'Масло ДВС',
                    onTap: () => model.openHistoryScreen(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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
                        Expanded(
                          child: Text(
                            upperLeftText,
                            style: AppTextStyles.hint
                                .copyWith(color: AppColors.greyText),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            upperRightText,
                            style: AppTextStyles.hint
                                .copyWith(color: AppColors.greyText),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lowerLeftText,
                            style: AppTextStyles.hint
                                .copyWith(color: AppColors.greyText),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lowerRightText,
                            style: AppTextStyles.hint
                                .copyWith(color: AppColors.greyText),
                          ),
                        ),
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
