import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/photo_list_widget.dart';
import 'package:autospectechnics/ui/screens/repair_history/completed_repair/completed_repair_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CompletedRepairScreen extends StatelessWidget {
  const CompletedRepairScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: 'Выполненная работа',
        hasBackButton: true,
      ),
      body: _BodyWidget(),
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
        context.select((CompletedRepairViewModel vm) => vm.isLoadingProgress);
    final configuration = context.select(
        (CompletedRepairViewModel vm) => vm.completedRepairWidgetConfiguration);
    return isLoadingProgress
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            children: [
              Row(
                children: [
                  SvgPicture.asset(configuration.vehicleNodeIconName),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          configuration.title,
                          style: AppTextStyles.semiBold.copyWith(
                            color: AppColors.black,
                          ),
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
              const SizedBox(height: 16),
              const _BreakageWidget(),
            ],
          );
  }
}

class _BreakageWidget extends StatefulWidget {
  const _BreakageWidget({Key? key}) : super(key: key);

  @override
  State<_BreakageWidget> createState() => _BreakageWidgetState();
}

class _BreakageWidgetState extends State<_BreakageWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  bool _isActive = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleContainer() {
    // print(_animation.status);
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
      setState(() {
        _isActive = true;
      });
    } else {
      _controller.animateBack(0, duration: const Duration(milliseconds: 500));
      setState(() {
        _isActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final configuration = context.select(
        (CompletedRepairViewModel vm) => vm.breakageWidgetConfiguration);
    return configuration.description.isNotEmpty
        ? Column(
            children: [
              InkWell(
                onTap: () => _toggleContainer(),
                child: _BreakageHeaderWidget(isActive: _isActive),
              ),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          configuration.vehicleNodeIconName,
                          color: AppColors.greyText,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            configuration.title,
                            style: AppTextStyles.semiBold.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(
                          configuration.dangerLevelIconName,
                          color: AppColors.greyText,
                        ),
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
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          AppColors.greyText, BlendMode.color),
                      child:
                          PhotoListWidget(photosURL: configuration.photosURL),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      configuration.description,
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _BreakageHeaderWidget extends StatelessWidget {
  final bool isActive;

  const _BreakageHeaderWidget({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.greyText : AppColors.black;
    final arrowIcon = isActive
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              'Неисправность',
              style: AppTextStyles.hint.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              arrowIcon,
              color: color,
            ),
          ],
        ),
      ],
    );
  }
}
