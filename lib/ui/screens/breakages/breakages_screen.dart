import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/breakages/breakages_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BreakagesScreen extends StatelessWidget {
  const BreakagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BreakagesViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Поломки',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        text: 'Добавить поломку',
        onPressed: () => model.openAddingBreakageScreen(context),
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
    final model = context.read<BreakagesViewModel>();
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (_, __) => _BreakageCardWidget(
        onTap: () => model.openBreakageDetailsScreen(context),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
    );
  }
}

class _BreakageCardWidget extends StatelessWidget {
  final void Function()? onTap;
  const _BreakageCardWidget({
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
              SvgPicture.asset(AppSvgs.chassis),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Лопнула рессора',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(AppSvgs.criticalBreakage),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Уровень: критический',
                            style: AppTextStyles.hint.copyWith(
                              color: AppColors.greyText,
                            ),
                            overflow: TextOverflow.ellipsis,
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
