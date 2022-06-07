import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/photo_list_widget.dart';
import 'package:autospectechnics/ui/screens/breakages/breakage_details/breakage_details_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BreakageDetailsScreen extends StatelessWidget {
  const BreakageDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BreakageDetailsViewModel>();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Поломки',
        hasBackButton: true,
        onDeleteButtonTap: () => model.onDeleteButtonTap(context),
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Редактировать'),
        onPressed: () => model.openUpdatingBreakageScreen(context),
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
    final model = context.read<BreakageDetailsViewModel>();
    final isLoadingProgress =
        context.select((BreakageDetailsViewModel vm) => vm.isLoadingProgress);
    final isUpdatingProgress =
        context.select((BreakageDetailsViewModel vm) => vm.isUpdatingProgress);
    final configuration = context.select(
        (BreakageDetailsViewModel vm) => vm.breakageWidgetConfiguration);
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
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => model.fixBreakage(context),
                    child: isUpdatingProgress
                        ? const SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                        : SvgPicture.asset(AppSvgs.fixIcon),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      fixedSize: const Size(40, 40),
                      primary: AppColors.white,
                      shape: const CircleBorder(),
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(configuration.dangerLevelIconName),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      configuration.dangerLevel,
                      style: AppTextStyles.hint.copyWith(
                        color: AppColors.greyText,
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
              ),
            ],
          );
  }
}
