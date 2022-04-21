import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/routine_maintenance_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class RoutineMaintenanceScreen extends StatefulWidget {
  const RoutineMaintenanceScreen({Key? key}) : super(key: key);

  @override
  _RoutineMaintenanceScreenState createState() =>
      _RoutineMaintenanceScreenState();
}

class _RoutineMaintenanceScreenState extends State<RoutineMaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<RoutineMaintenanceViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'ТО',
        hasBackButton: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: const [
          _VehicleNodeWidget(),
          SizedBox(height: 16),
          _VehicleNodeWidget(),
          SizedBox(height: 16),
          _VehicleNodeWidget(),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        text: 'Записать моточасы и пробег',
        onPressed: () => model.openWritingEngineHoursScreen(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _VehicleNodeWidget extends StatefulWidget {
  const _VehicleNodeWidget({Key? key}) : super(key: key);

  @override
  State<_VehicleNodeWidget> createState() => __VehicleNodeWidgetState();
}

class __VehicleNodeWidgetState extends State<_VehicleNodeWidget>
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
    return DecoratedBox(
      decoration: AppBoxDecorations.cardBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _toggleContainer(),
              child: _VehicleNodeHeaderWidget(isActive: _isActive),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              child: Column(
                children: const [
                  SizedBox(height: 8),
                  _WorkInfoWidget(),
                  SizedBox(height: 8),
                  _WorkInfoWidget(),
                  SizedBox(height: 8),
                  _WorkInfoWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleNodeHeaderWidget extends StatelessWidget {
  final bool isActive;

  const _VehicleNodeHeaderWidget({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.blue : AppColors.black;
    final arrowIcon = isActive
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    return Row(
      children: [
        SvgPicture.asset(
          AppSvgs.engine,
          color: color,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'ДВС',
            style: AppTextStyles.regular20.copyWith(
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          arrowIcon,
          color: color,
        ),
      ],
    );
  }
}

class _WorkInfoWidget extends StatelessWidget {
  const _WorkInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Моторное масло',
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
              Text(
                'Осталось 125 мч',
                style: AppTextStyles.hint.copyWith(
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 4),
              const RemainingResourceProgressBarWidget(
                color: AppColors.green,
                value: 0.8,
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Icon(Icons.refresh),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.blue,
            fixedSize: const Size(40, 40),
            primary: AppColors.white,
            shape: const CircleBorder(),
            side: BorderSide.none,
          ),
        ),
      ],
    );
  }
}
