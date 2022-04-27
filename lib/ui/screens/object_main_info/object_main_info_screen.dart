import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/image_widget.dart';
import 'package:autospectechnics/ui/screens/object_main_info/object_main_info_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ObjectMainInfoScreen extends StatelessWidget {
  const ObjectMainInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Название объекта',
        hasBackButton: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.greyBorder,
              ),
              Text(
                '12.12.2021 - 01.02.2022',
                style: AppTextStyles.hint.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _ObjectInfoWidget(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (_, __) => const _VehicleWidget(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Редактировать'),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _VehicleWidget extends StatelessWidget {
  const _VehicleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ObjectMainInfoViewModel>();
    return InkWell(
      onTap: () => model.openVehicleInfoScreen(context),
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(
                  left: 1, bottom: 1, top: 1), //Отступы, чтобы было видно рамку
              // TODO Закомментировал потому что подключил сервер и теперь нужно вбивать адрес картинкиchild: ImageWidget(imageName: AppImages.valdai),
            ),
            SizedBox(width: 16),
            Expanded(child: _VehicleInfoWidget()),
          ],
        ),
      ),
    );
  }
}

class _VehicleInfoWidget extends StatelessWidget {
  const _VehicleInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ГАЗ-3310 Валдай',
            style: AppTextStyles.semiBold.copyWith(
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SvgPicture.asset(AppSvgs.minorBreakage),
                    Text(
                      'Готовность',
                      style: AppTextStyles.hint.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '25/40 м.ч.',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'Ресурс',
                      style: AppTextStyles.hint.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ObjectInfoWidget extends StatefulWidget {
  const _ObjectInfoWidget({Key? key}) : super(key: key);

  @override
  State<_ObjectInfoWidget> createState() => _ObjectInfoWidgetState();
}

class _ObjectInfoWidgetState extends State<_ObjectInfoWidget>
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
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, __) => Image.asset(AppImages.mitsubishi), //TODO картинка обрезанная потому что она в таком формате скачана
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: 4),
              ),
              const SizedBox(height: 16),
              Text(
                '45 дней до начала',
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Техника',
                    style: AppTextStyles.regular16.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(AppSvgs.minorBreakage),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Предстоит полная замена забора по периметру всей парковки',
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        InkWell(
          onTap: () => _toggleContainer(),
          child: _ObjectInfoHeaderWidget(isActive: _isActive),
        ),
      ],
    );
  }
}

class _ObjectInfoHeaderWidget extends StatelessWidget {
  final bool isActive;

  const _ObjectInfoHeaderWidget({
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
              'Инофрмация об объекте',
              style: AppTextStyles.hint.copyWith(
                color: color,
              ),
            ),
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
