import 'package:autospectechnics/ui/global_widgets/app_bar_widget.dart';
import 'package:autospectechnics/ui/global_widgets/floating_button_widget.dart';
import 'package:autospectechnics/ui/screens/main_tabs/widgets/network_image_widget.dart';
import 'package:autospectechnics/ui/screens/vehicle_information/vehicle_information_view_model.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleInformationScreen extends StatelessWidget {
  const VehicleInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VehicleInformationViewModel>();
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Авто',
        hasBackButton: true,
      ),
      body: const _BodyWidget(),
      floatingActionButton: FloatingButtonWidget(
          child: const Text('Редактировать'),
          onPressed: () => model.openAddingVehicleScreen(context),
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
    final isLoadingProgress = context
        .select((VehicleInformationViewModel vm) => vm.isLoadingProgress);
    final configuration = context.select((VehicleInformationViewModel vm) =>
        vm.vehicleInformationWidgetConfiguration);
    return isLoadingProgress
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              AspectRatio(
                aspectRatio: 1.8,
                child: NetworkImageWidget(url: configuration.imageURL),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoBlockWidget(
                      title: 'Модель',
                      text: configuration.model,
                    ),
                    const SizedBox(height: 8),
                    _InfoBlockWidget(
                      title: 'Пробег',
                      text: configuration.mileage,
                    ),
                    const SizedBox(height: 8),
                    _InfoBlockWidget(
                      title: 'Гос. номер',
                      text: configuration.licensePlate,
                    ),
                    const SizedBox(height: 8),
                    _InfoBlockWidget(
                      title: 'Описание',
                      text: configuration.description,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

class _InfoBlockWidget extends StatelessWidget {
  const _InfoBlockWidget({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.hint.copyWith(color: AppColors.greyText),
        ),
        Text(
          text,
          style: AppTextStyles.regular16.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}
