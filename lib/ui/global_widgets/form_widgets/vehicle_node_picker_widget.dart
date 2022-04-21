import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NodeType {
  engine,
  bodywork,
  transmission,
  chassis,
  technicalLiquids,
  otherNodes
}

//TODO Реализовать перекрашивание выбранных квадратиков
class VehicleNodePickerWidget extends StatelessWidget {
  const VehicleNodePickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NodeWidget(
              iconName: AppSvgs.engine,
              title: 'ДВС',
              color: AppColors.greyText,
            ),
            _NodeWidget(
              iconName: AppSvgs.bodywork,
              title: 'Кузов',
              color: AppColors.blue,
            ),
            _NodeWidget(
              iconName: AppSvgs.transmission,
              title: 'КПП',
              color: AppColors.greyText,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NodeWidget(
              iconName: AppSvgs.chassis,
              title: 'Ходовая',
              color: AppColors.greyText,
            ),
            _NodeWidget(
              iconName: AppSvgs.technicalLiquids,
              title: 'Жидкости',
              color: AppColors.greyText,
            ),
            _NodeWidget(
              iconName: AppSvgs.otherNodes,
              title: 'Прочие',
              color: AppColors.greyText,
            ),
          ],
        ),
      ],
    );
  }
}

class _NodeWidget extends StatelessWidget {
  final String iconName;
  final String title;
  //TODO Цвет брать в зависимости от того выбрана карточка или нет, не передавать явно
  final Color color;
  const _NodeWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            //TODO Ширину рамки брать в зависимости от того выбрана карточка или нет
            width: color == AppColors.blue ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconName,
              color: color,
            ),
            Text(
              title,
              style: AppTextStyles.hint.copyWith(
                color: color,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
