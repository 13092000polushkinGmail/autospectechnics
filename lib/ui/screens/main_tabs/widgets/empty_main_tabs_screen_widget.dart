import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyMainTabsScreenWidget extends StatelessWidget {
  const EmptyMainTabsScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Автопарк пуст',
              style: AppTextStyles.semiBold.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Пожалуйста, дождитесь окончания загрузки.',
              style: AppTextStyles.regular16.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Если техника не появится в списке, то добавьте свой первый автомобиль с помощью кнопки внизу экрана.',
              style: AppTextStyles.regular16.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Если Вы уверены, что техника должна быть, обновите страницу.',
              style: AppTextStyles.regular16.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => model.getAllInfo(context),
              child: const Text('Обновить страницу'),
            ),
          ],
        ),
      ),
    );
  }
}
