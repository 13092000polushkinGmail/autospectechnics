import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/recommendations/recommendations_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RecommendationsViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Рекомендации',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Добавить рекомендацию'),
        onPressed: () => model.openAddingRecommendationScreen(context),
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
        context.select((RecommendationsViewModel vm) => vm.isLoadingProgress);
    final recommendationList =
        context.select((RecommendationsViewModel vm) => vm.recommendationList);
    return isLoadingProgress
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: recommendationList.length,
            itemBuilder: (_, index) => _RecommendationCardWidget(index: index),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
          );
  }
}

class _RecommendationCardWidget extends StatelessWidget {
  final int index;
  const _RecommendationCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RecommendationsViewModel>();
    final configuration = context.select((RecommendationsViewModel vm) =>
        vm.getRecommendationCardWidgetConfiguration(index));
    return InkWell(
      onTap: () => model.openRecommendationDetailsScreen(context, index),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(configuration.vehicleNodeIconName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      configuration.title,
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      configuration.description,
                      style: AppTextStyles.hint.copyWith(
                        color: AppColors.greyText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
