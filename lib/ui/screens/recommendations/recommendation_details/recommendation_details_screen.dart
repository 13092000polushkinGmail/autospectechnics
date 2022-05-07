import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/photo_list_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendation_details/recommendation_details_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
        child: const Text('Редактировать'),
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
    final isLoadingProgress = context
        .select((RecommendationDetailsViewModel vm) => vm.isLoadingProgress);
    final configuration = context.select((RecommendationDetailsViewModel vm) =>
        vm.recommendationWidgetConfiguration);
    return isLoadingProgress
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
            children: [
              Row(
                children: [
                  SvgPicture.asset(configuration.vehicleNodeIconName),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      configuration.title,
                      style: AppTextStyles.semiBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              PhotoListWidget(photosURL: configuration.photosURL),
              const SizedBox(height: 16),
              Text(
                configuration.description,
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              )
            ],
          );
  }
}
