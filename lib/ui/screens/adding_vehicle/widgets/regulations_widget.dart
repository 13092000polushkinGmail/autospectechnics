import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/header_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/text_field_template_widget.dart';
import 'package:autospectechnics/ui/global_widgets/form_widgets/vehicle_node_picker_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/global_widgets/stepper_widget.dart';
import 'package:autospectechnics/ui/theme/app_box_decorations.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RegulationsWidget extends StatelessWidget {
  const RegulationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    final stepperConfiguration =
        context.select((AddingVehicleViewModel vm) => vm.stepperConfiguration);
    final routineMaintenanceAmount = context
        .select((AddingVehicleViewModel vm) => vm.routineMaintenanceAmount);
    final isLoadingProgress =
        context.select((AddingVehicleViewModel vm) => vm.isLoadingProgress);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регламенты'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => model.decrementCurrentTabIndex(),
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          StepperWidget(configuration: stepperConfiguration),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => model.addNewRoutineMaintenance(),
            child: const Text(
              'Добавить регламент',
              style: AppTextStyles.regular16,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _RoutineMaintenanceWidget(index: index),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: routineMaintenanceAmount,
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        child: isLoadingProgress
            ? const CircularProgressIndicator()
            : const Text('Сохранить'),
        onPressed: () => model.saveToDatabase(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _RoutineMaintenanceWidget extends StatefulWidget {
  final int index;
  const _RoutineMaintenanceWidget({Key? key, required this.index})
      : super(key: key);

  @override
  State<_RoutineMaintenanceWidget> createState() =>
      _RoutineMaintenanceWidgetState();
}

class _RoutineMaintenanceWidgetState extends State<_RoutineMaintenanceWidget>
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
    final model = context.read<AddingVehicleViewModel>();
    final configuration =
        model.getRoutineMaintenanceWidgetConfiguration(widget.index, _isActive);
    return configuration != null
        ? DecoratedBox(
            decoration: AppBoxDecorations.cardBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _toggleContainer(),
                    child:
                        _HeaderWidget(index: widget.index, isActive: _isActive),
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    child: Column(
                      children: [
                        const HeaderWidget(
                          text: 'Для какого узла регламент?',
                        ),
                        const SizedBox(height: 16),
                        VehicleNodePickerWidget(
                          onVehicleNodeTapSelectIndex: (index) {
                            configuration.setVehicleNode(index);
                            setState(() {});
                          },
                          selectedIndex: configuration.selectedIndex,
                        ),
                        const SizedBox(height: 24),
                        TextFieldTemplateWidget(
                            controller: configuration.titleTextController,
                            onTap: () {
                              configuration.notifyAboutChanges();
                              setState(() {});
                            },
                            hintText: 'Название'),
                        const SizedBox(height: 16),
                        TextFieldTemplateWidget(
                          controller: configuration.periodicityTextController,
                          onTap: () {
                            configuration.notifyAboutChanges();
                            setState(() {});
                          },
                          hintText: 'Периодичность, м.ч.',
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => model.deleteRoutineMaintenance(
                                  context: context, index: widget.index),
                              child: const Text('Удалить'),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                if (model.trySaveRoutineMaintenance(
                                    context: context, index: widget.index)) {
                                  _toggleContainer();
                                }
                              },
                              child: const Text('ОК'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
    //       child: ListView.separated(
    //           scrollDirection: Axis.vertical,
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           itemBuilder: (_, __) => Text(
    //                 'Замена масляного фильтра и масла ДВС',
    //                 style: AppTextStyles.hint
    //                     .copyWith(color: AppColors.greyText),
    //               ),
    //           separatorBuilder: (_, __) => const SizedBox(height: 4),
    //           itemCount: 4),
    //     ),
    //   ],
    // ),],);
  }
}

class _HeaderWidget extends StatelessWidget {
  final int index;
  final bool isActive;

  const _HeaderWidget({
    Key? key,
    required this.index,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    final configuration =
        model.getRoutineMaintenanceWidgetConfiguration(index, isActive);
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
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Text(
    //       'Добавить регламент',
    //       style: AppTextStyles.regular16.copyWith(
    //         color: AppColors.blue,
    //       ),
    //     ),
    // Row(
    //   children: [
    //     Expanded(
    //       child: Text(
    //         'Использовать стандартные для данного типа техники регламенты?',
    // style: AppTextStyles.regular16.copyWith(
    //   color: AppColors.black,
    // ),
    //       ),
    //     ),
    //     const SizedBox(height: 4),
    //     Switch(value: true, onChanged: (onwvwv) {}),
    //   ],
    // ),
    // Icon(
    //   arrowIcon,
    //   color: color,
    // ),
    //   ],
    // );
  }
}
