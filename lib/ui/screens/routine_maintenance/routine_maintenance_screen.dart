import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:autospectechnics/domain/entities/routine_maintenance.dart';
import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/remaining_resource_progress_bar_widget.dart';
import 'package:autospectechnics/ui/screens/routine_maintenance/routine_maintenance_view_model.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';

class RoutineMaintenanceScreen extends StatelessWidget {
  const RoutineMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RoutineMaintenanceViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'ТО',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
        child: const Text('Записать моточасы и пробег'),
        onPressed: () => model.openWritingEngineHoursScreen(context),
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
    final model = context.watch<RoutineMaintenanceViewModel>();
    final vehicleNodeDataList = model.vehicleNodeDataList;
    return model.isDataLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
            itemCount: vehicleNodeDataList.length,
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
    final model = context.watch<RoutineMaintenanceViewModel>();
    final vehicleNodeDataList = model.vehicleNodeDataList;
    final headerConfiguration =
        vehicleNodeDataList[widget.vehicleNodeDataIndex].headerConfiguration;
    final routineMaintenanceList =
        vehicleNodeDataList[widget.vehicleNodeDataIndex].routineMaintenanceList;
    return DecoratedBox(
      decoration: AppBoxDecorations.cardBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _toggleContainer(),
              child: _VehicleNodeHeaderWidget(
                isActive: _isActive,
                configuration: headerConfiguration,
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
    );
  }
}

class _VehicleNodeHeaderWidget extends StatelessWidget {
  final bool isActive;
  final VehicleNodeHeaderWidgetConfiguration configuration;

  const _VehicleNodeHeaderWidget({
    Key? key,
    required this.isActive,
    required this.configuration,
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
          configuration.iconName,
          color: color,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            configuration.title,
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
  final int vehicleNodeDataIndex;
  final int routineMaintenanceIndex;

  const _WorkInfoWidget({
    Key? key,
    required this.vehicleNodeDataIndex,
    required this.routineMaintenanceIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RoutineMaintenanceViewModel>();
    final vehicleNodeDataList = model.vehicleNodeDataList;
    final routineMaintenanceList =
        vehicleNodeDataList[vehicleNodeDataIndex].routineMaintenanceList;
    final routineMaintenance = routineMaintenanceList[routineMaintenanceIndex];
    final isRoutineMaintenanceUpdating = context.select(
        (RoutineMaintenanceViewModel vm) => vm.isRoutineMaintenanceUpdating);
    final engineHoursReserve =
        routineMaintenance.periodicity - routineMaintenance.engineHoursValue;
    final progressIndicatorValue = 1 -
        routineMaintenance.engineHoursValue / routineMaintenance.periodicity;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routineMaintenance.title,
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.black,
                ),
              ),
              Text(
                'Осталось $engineHoursReserve/${routineMaintenance.periodicity} мч',
                style: AppTextStyles.hint.copyWith(
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 4),
              RemainingResourceProgressBarWidget(
                value: progressIndicatorValue,
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => model.resetEngineHoursValue(
            objectId: routineMaintenance.objectId,
            vehicleNodeDataIndex: vehicleNodeDataIndex,
            routineMaintenanceIndex: routineMaintenanceIndex,
          ),
          //TODO Применяется ко всем кнопкам обновления, они крутятся одновременно, подумать, как исправить
          child: isRoutineMaintenanceUpdating
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
    );
  }
}
