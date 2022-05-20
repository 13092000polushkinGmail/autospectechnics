import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/photo_list_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
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
    final title = context.select((ObjectMainInfoViewModel vm) =>
        vm.informationWidgetConfiguration.buildingObjectTitle);
    return Scaffold(
      appBar: AppBarWidget(
        title: title,
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
    final isLoadingProgress =
        context.select((ObjectMainInfoViewModel vm) => vm.isLoadingProgress);
    final informationWidgetConfiguration = context.select(
        (ObjectMainInfoViewModel vm) => vm.informationWidgetConfiguration);
    final vehiclesListLength =
        context.select((ObjectMainInfoViewModel vm) => vm.vehiclesListLength);
    return isLoadingProgress
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
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
                    '${informationWidgetConfiguration.startDate} - ${informationWidgetConfiguration.finishDate}',
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
                itemCount: vehiclesListLength,
                itemBuilder: (_, index) => _VehicleWidget(index: index),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ],
          );
  }
}

class _VehicleWidget extends StatelessWidget {
  final int index;
  const _VehicleWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ObjectMainInfoViewModel>();
    final vehicleWidgetConfiguration = context.select(
      (ObjectMainInfoViewModel vm) => vm.getVehicleWidgetConfiguration(index),
    );
    return InkWell(
      onTap: () => model.openVehicleInfoScreen(context, index),
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: AppBoxDecorations.cardBoxDecoration,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 1, bottom: 1, top: 1), //Отступы, чтобы было видно рамку
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 108,
                  width: 116,
                  child: NetworkImageWidget(
                      url: vehicleWidgetConfiguration.imageURL),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _VehicleInfoWidget(index: index)),
          ],
        ),
      ),
    );
  }
}

class _VehicleInfoWidget extends StatelessWidget {
  final int index;
  const _VehicleInfoWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleWidgetConfiguration = context.select(
      (ObjectMainInfoViewModel vm) => vm.getVehicleWidgetConfiguration(index),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            vehicleWidgetConfiguration.title,
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
                    SvgPicture.asset(vehicleWidgetConfiguration.breakageIcon),
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
                child: vehicleWidgetConfiguration.remainEngineHours == null
                    ? Text(
                        'Регламенты не заданы',
                        style: AppTextStyles.hint.copyWith(
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        children: [
                          Text(
                            '${vehicleWidgetConfiguration.remainEngineHours}/${vehicleWidgetConfiguration.requiredEngineHours}',
                            style: AppTextStyles.regular16.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            'Ресурс (м.ч.)',
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
    final informationWidgetConfiguration = context.select(
        (ObjectMainInfoViewModel vm) => vm.informationWidgetConfiguration);
    return Column(
      children: [
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoListWidget(
                  photosURL: informationWidgetConfiguration.photosURL),
              const SizedBox(height: 16),
              Text(
                '${informationWidgetConfiguration.daysInfo.daysAmount} ${informationWidgetConfiguration.daysInfo.daysText.toLowerCase()}',
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              if (informationWidgetConfiguration.breakageIcon != null)
                Row(
                  children: [
                    Text(
                      'Техника',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                        informationWidgetConfiguration.breakageIcon!),
                  ],
                )
              else
                Text(
                  'Техника не выбрана',
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.black,
                  ),
                ),
              const SizedBox(height: 8),
              if (informationWidgetConfiguration.description.isNotEmpty)
                Text(
                  informationWidgetConfiguration.description,
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
