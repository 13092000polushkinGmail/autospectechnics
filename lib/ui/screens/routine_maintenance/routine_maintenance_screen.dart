import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/routine_maintenance_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';

class RoutineMaintenanceScreen extends StatelessWidget {
  const RoutineMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: 'ТО',
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
    final isDataLoading =
        context.select((RoutineMaintenanceViewModel vm) => vm.isDataLoading);
    final vehicleNodeAmount = context
        .select((RoutineMaintenanceViewModel vm) => vm.vehicleNodeAmount);
    return isDataLoading
        ? const Center(child: CircularProgressIndicator())
        : vehicleNodeAmount == 0
            ? Center(
                child: Text(
                  'Регламенты не заданы',
                  style:
                      AppTextStyles.regular16.copyWith(color: AppColors.black),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: vehicleNodeAmount,
                itemBuilder: (_, index) =>
                    _VehicleNodeWidget(vehicleNodeDataIndex: index),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              );
  }
}

class _VehicleNodeWidget extends StatefulWidget {
  final int vehicleNodeDataIndex;

  const _VehicleNodeWidget({
    Key? key,
    required this.vehicleNodeDataIndex,
  }) : super(key: key);

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
    final routineMaintenanceList = context.select(
        (RoutineMaintenanceViewModel vm) =>
            vm.getRoutineMaintenanceList(widget.vehicleNodeDataIndex));
    return routineMaintenanceList != null
        ? DecoratedBox(
            decoration: AppBoxDecorations.cardBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _toggleContainer(),
                    child: _VehicleNodeHeaderWidget(
                      isActive: _isActive,
                      index: widget.vehicleNodeDataIndex,
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    child: ListView.separated(
                      itemCount: routineMaintenanceList.length,
                      itemBuilder: (_, index) => _WorkInfoWidget(
                        vehicleNodeDataIndex: widget.vehicleNodeDataIndex,
                        routineMaintenanceIndex: index,
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _VehicleNodeHeaderWidget extends StatelessWidget {
  final bool isActive;
  final int index;

  const _VehicleNodeHeaderWidget({
    Key? key,
    required this.isActive,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RoutineMaintenanceViewModel>();
    final configuration =
        model.getVehicleNodeHeaderWidgetConfiguration(index, isActive);
    return configuration != null
        ? Row(
            children: [
              SvgPicture.asset(
                configuration.iconName,
                color: configuration.color,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  configuration.title,
                  style: AppTextStyles.regular20.copyWith(
                    color: configuration.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                configuration.arrowIcon,
                color: configuration.color,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _WorkInfoWidget extends StatelessWidget {
  final int vehicleNodeDataIndex;
  final int routineMaintenanceIndex;

  const _WorkInfoWidget({
    Key? key,
    required this.vehicleNodeDataIndex,
    required this.routineMaintenanceIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isRoutineMaintenanceUpdating = context.select(
    //     (RoutineMaintenanceViewModel vm) => vm.isRoutineMaintenanceUpdating);
    final model = context.read<RoutineMaintenanceViewModel>();
    final configuration = model.getWorkInfoWidgetConfiguration(
        vehicleNodeDataIndex, routineMaintenanceIndex);
    return configuration != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      configuration.title,
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      configuration.engineHoursReserve,
                      style: AppTextStyles.hint.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RemainingResourceProgressBarWidget(
                      value: configuration.progressIndicatorValue,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => model.resetEngineHoursValue(
                  vehicleNodeDataIndex: vehicleNodeDataIndex,
                  routineMaintenanceIndex: routineMaintenanceIndex,
                  context: context,
                ),
                //TODO Кнопки обновления не меняются на крутилки. Оставил, потому что надо исправлять более важные недоработки
                child: configuration.isUpdating
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.refresh),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  fixedSize: const Size(40, 40),
                  primary: AppColors.white,
                  shape: const CircleBorder(),
                  side: BorderSide.none,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
