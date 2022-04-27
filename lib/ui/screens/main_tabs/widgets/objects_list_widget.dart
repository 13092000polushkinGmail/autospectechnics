import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/image_widget.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ObjectsListWidget extends StatelessWidget {
  const ObjectsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Объекты',
        hasBackButton: false,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => const _ObjectWidget(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
          const SizedBox(height: 16),
          const _CompletedObjectsWidget(),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Добавить объект'),
        onPressed: () => model.openAddingObjectScreen(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ObjectWidget extends StatelessWidget {
  const _ObjectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainTabsViewModel>();
    return InkWell(
      onTap: () => model.openObjectInfoScreen(context),
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(
                  left: 1, bottom: 1, top: 1), //Отступы, чтобы было видно рамку
              // TODO Закомментировал потому что подключил сервер и теперь нужно вбивать адрес картинки child: ImageWidget(imageName: AppImages.mitsubishi),
            ),
            SizedBox(width: 16),
            Expanded(child: _ObjectInfoWidget()),
          ],
        ),
      ),
    );
  }
}

class _ObjectInfoWidget extends StatelessWidget {
  const _ObjectInfoWidget({
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
            'Mitsubishi Металлургов',
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
                    SvgPicture.asset(AppSvgs.significantBreakage),
                    Text(
                      'Техника',
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
                      '25 дней',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'До начала',
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

//TODO Возможно сделать tabbar вверху страницы, чтобы разделить готовые объекты, в работе и выполненные
class _CompletedObjectsWidget extends StatefulWidget {
  const _CompletedObjectsWidget({Key? key}) : super(key: key);

  @override
  State<_CompletedObjectsWidget> createState() =>
      __CompletedObjectsWidgetState();
}

class __CompletedObjectsWidgetState extends State<_CompletedObjectsWidget>
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
          child: _HeaderWidget(isActive: _isActive),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(AppColors.greyText, BlendMode.color),
                  child: _ObjectWidget()),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      ],
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final bool isActive;

  const _HeaderWidget({
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
              'Выполненные',
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
