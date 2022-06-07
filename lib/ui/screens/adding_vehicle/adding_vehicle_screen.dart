import 'package:autospectechnics/ui/screens/adding_vehicle/adding_vehicle_view_model.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_form_main_info_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/regulations_widget.dart';
import 'package:autospectechnics/ui/screens/adding_vehicle/widgets/vehicle_type_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingVehicleScreen extends StatelessWidget {
  const AddingVehicleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    final currentIndex = context.select(
      (AddingVehicleViewModel vm) => vm.currentTabIndex,
    );
    return IndexedStack(
      index: currentIndex,
      children: const [
        VehicleFormMainInfoWidget(),
        VehicleTypePickerWidget(),
        RegulationsWidget(),
      ],
    );
  }
}