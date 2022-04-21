import 'package:autospectechnics/resources/resources.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_stepper_widget.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class VehicleTypePickerWidget extends StatelessWidget {
  const VehicleTypePickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddingVehicleViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тип ТС'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => model.decrementCurrentTabIndex(),
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
        children: [
          const VehicleStepperWidget(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _VehicleTypeWidget(
                iconName: AppSvgs.passengerCar,
                title: 'Легковой автомобиль',
                color: AppColors.greyText,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.lowTonnageTruck,
                title: 'Малотоннажный грузовик',
                color: AppColors.blue,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.mediumTonnageTruck,
                title: 'Среднетоннажный грузовик',
                color: AppColors.greyText,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _VehicleTypeWidget(
                iconName: AppSvgs.miniLoader,
                title: 'Мини-погрузчик',
                color: AppColors.greyText,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.excavator,
                title: 'Экскаватор',
                color: AppColors.greyText,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.cementMixer,
                title: 'Бетоновоз',
                color: AppColors.greyText,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _VehicleTypeWidget(
                iconName: AppSvgs.truckCrane,
                title: 'Манипулятор и автокран',
                color: AppColors.greyText,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.dumpTruck,
                title: 'Самосвал и тонар',
                color: AppColors.greyText,
              ),
              _VehicleTypeWidget(
                iconName: AppSvgs.other,
                title: 'Другое',
                color: AppColors.greyText,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        text: 'Далее',
        onPressed: () => model.incrementCurrentTabIndex(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//TODO Реализовать перекрашивание выбранных квадратиков
class _VehicleTypeWidget extends StatelessWidget {
  final String iconName;
  final String title;
  //TODO Цвет брать в зависимости от того выбрана карточка или нет, не передавать явно
  final Color color;
  const _VehicleTypeWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
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
              style: AppTextStyles.smallLabels.copyWith(
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
