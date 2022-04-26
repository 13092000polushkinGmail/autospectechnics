import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BreakageDetailsScreen extends StatelessWidget {
  const BreakageDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Поломки',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Устранено'),
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
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        Row(
          children: [
            SvgPicture.asset(AppSvgs.chassis),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Лопнула задняя левая рессора',
                style: AppTextStyles.semiBold.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SvgPicture.asset(AppSvgs.criticalBreakage),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Уровень: критический',
                style: AppTextStyles.hint.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => Image.asset(AppImages.valdai),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: 4),
        ),
        const SizedBox(height: 16),
        Text(
          'Половина листов задней левой рессоры лопнула, эксплуатация особенно с грузом невозможна. Менять только вместе с задней правой, потому что рессоры просели.',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
