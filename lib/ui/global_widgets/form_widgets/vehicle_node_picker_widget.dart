import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';

class VehicleNodePickerWidget extends StatelessWidget {
  final void Function(int index) onVehicleNodeTapSelectIndex;
  final int selectedIndex;
  const VehicleNodePickerWidget({
    Key? key,
    required this.onVehicleNodeTapSelectIndex,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.engine,
                title: 'ДВС',
                currentVehicleNodeIndex: 0,
                selectedVehicleNodeIndex: selectedIndex,
                //TODO Может быть передавать немного по-другому, как еще не придумал
                onTap: () => onVehicleNodeTapSelectIndex(0),
              ),
            ),
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.bodywork,
                title: 'Кузов',
                 currentVehicleNodeIndex: 1,
                selectedVehicleNodeIndex: selectedIndex,
                onTap: () => onVehicleNodeTapSelectIndex(1),
              ),
            ),
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.transmission,
                title: 'КПП',
                 currentVehicleNodeIndex: 2,
                selectedVehicleNodeIndex: selectedIndex,
                onTap: () => onVehicleNodeTapSelectIndex(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.chassis,
                title: 'Ходовая',
                 currentVehicleNodeIndex: 3,
                selectedVehicleNodeIndex: selectedIndex,
                onTap: () => onVehicleNodeTapSelectIndex(3),
              ),
            ),
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.technicalLiquids,
                title: 'Жидкости',
                 currentVehicleNodeIndex: 4,
                selectedVehicleNodeIndex: selectedIndex,
                onTap: () => onVehicleNodeTapSelectIndex(4),
              ),
            ),
            _NodeWidget(
              configuration: NodeWidgetConfiguration(
                iconName: AppSvgs.otherNodes,
                title: 'Прочие',
                 currentVehicleNodeIndex: 5,
                selectedVehicleNodeIndex: selectedIndex,
                onTap: () => onVehicleNodeTapSelectIndex(5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NodeWidget extends StatelessWidget {
  final NodeWidgetConfiguration configuration;
  const _NodeWidget({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: configuration.onTap,
      child: SizedBox(
        width: 80,
        height: 80,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: configuration.color,
              width: configuration.borderWidth,
            ),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                configuration.iconName,
                color: configuration.color,
              ),
              Text(
                configuration.title,
                style: AppTextStyles.hint.copyWith(
                  color: configuration.color,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

//TODO Геттеры попробовать сделать late полями
class NodeWidgetConfiguration {
  final String iconName;
  final String title;
  final int currentVehicleNodeIndex;
  final int selectedVehicleNodeIndex;
  final void Function() onTap;

  NodeWidgetConfiguration({
    required this.iconName,
    required this.title,
    required this.currentVehicleNodeIndex,
    required this.selectedVehicleNodeIndex,
    required this.onTap,
  });

  bool get _isSelected => currentVehicleNodeIndex == selectedVehicleNodeIndex;

  Color get color => _isSelected ? AppColors.blue : AppColors.greyText;

  double get borderWidth => _isSelected ? 1.5 : 1.0;
}
