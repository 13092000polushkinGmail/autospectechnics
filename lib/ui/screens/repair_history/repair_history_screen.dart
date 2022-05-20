import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/repair_history/repair_history_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RepairHistoryScreen extends StatelessWidget {
  const RepairHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RepairHistoryViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'История работ',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Добавить работу'),
        onPressed: () => model.openAddingCompletedRepairScreen(context),
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
        context.select((RepairHistoryViewModel vm) => vm.isLoadingProgress);
    final completedRepairList =
        context.select((RepairHistoryViewModel vm) => vm.completedRepairList);
    return isLoadingProgress
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: completedRepairList.length,
            itemBuilder: (_, index) => _RepairCardWidget(index: index),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            padding: const EdgeInsets.all(16),
          );
  }
}

class _RepairCardWidget extends StatelessWidget {
  final int index;
  const _RepairCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RepairHistoryViewModel>();
    final configuration = context.select((RepairHistoryViewModel vm) =>
        vm.getCompletedRepairCardWidgetConfiguration(index));
    return InkWell(
      onTap: () => model.openCompletedRepairScreen(context, index),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(
                configuration.vehicleNodeIconName,
                height: 40,
                width: 40,
              ),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            configuration.date,
                            style: AppTextStyles.hint.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            configuration.mileage,
                            style: AppTextStyles.hint.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                      ],
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
