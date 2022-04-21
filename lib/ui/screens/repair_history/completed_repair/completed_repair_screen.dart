import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompletedRepairScreen extends StatelessWidget {
  const CompletedRepairScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Выполненная работа',
        hasBackButton: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        children: [
          Row(
            children: [
              SvgPicture.asset(AppSvgs.chassis),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Замена задних рессор',
                      style: AppTextStyles.semiBold.copyWith(
                        color: AppColors.black,
                      ),
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
            'Задние рессоры с обеих сторон заменены на новые',
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          const _BreakageWidget(),
        ],
      ),
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
    return Column(
      children: [
        InkWell(
          onTap: () => _toggleContainer(),
          child: _BreakageHeaderWidget(isActive: _isActive),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          //TODO Полная копия виджета breakage details, сделать breakage details открытым, а не приватным и использовать здесь (возможно придется делать отдельный виджет, чтобы использорвать ColorFiltered только для картинок, остальным подвиджетам задать явный цвет )
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(AppColors.greyText, BlendMode.srcATop),
            child: Column(
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
            ),
          ),
        ),
      ],
    );
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
