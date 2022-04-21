import 'package:autospectechnics/resources/resources.dart';
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
        text: 'Добавить работу',
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
    final model = context.read<RepairHistoryViewModel>();
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (_, __) => _RepairCardWidget(
        onTap: () => model.openCompletedRepairScreen(context),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      padding: const EdgeInsets.all(16),
    );
  }
}

class _RepairCardWidget extends StatelessWidget {
  final void Function()? onTap;
  const _RepairCardWidget({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(
                AppSvgs.engine,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Замена свечей зажигания',
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
                            '22.12.2020',
                            style: AppTextStyles.hint.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '59000 км.',
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
