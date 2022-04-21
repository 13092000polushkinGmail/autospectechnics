import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecommendationDetailsScreen extends StatelessWidget {
  const RecommendationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Рекомендации',
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
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      children: [
        Row(
          children: [
            SvgPicture.asset(AppSvgs.chassis),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Заменить ступичный подшипник',
                style: AppTextStyles.semiBold.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Передний правый ступичный подшипник заменить, бренд - ILJIN',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.black,
          ),
        )
      ],
    );
  }
}
